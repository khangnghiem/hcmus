import json
import os
import sys
import scrapy
from itemadapter import ItemAdapter
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__ + "../../../..")))
from config import cfg
from data_ingestion.items import (
    CompanyOverviewItem,
    CompanyOverviewLoader,
    CompanyReviewItem,
    CompanyReviewLoader,
)
from w3lib.html import remove_tags


class CompanySpider(scrapy.Spider):
    name = "company"
    allowed_domains = ["1900.com.vn"]
    start_urls = [f"https://1900.com.vn/cong-ty?page={i}" for i in range(1, 2)]

    def parse_overview(self, response):
        overview = CompanyOverviewLoader(item=CompanyOverviewItem(), response=response)
        overview.add_xpath(
            field_name="website",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[1]/a/@href",
        )
        overview.add_xpath(
            field_name="phone_number",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[3]/span/text()",
        )
        overview.add_xpath(
            field_name="department",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[5]/a/@href",
        )
        overview.add_xpath(
            field_name="business_type",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[7]/span/text()",
        )
        overview.add_xpath(
            field_name="headquarter",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[2]/span/text()",
        )
        overview.add_xpath(
            field_name="scale",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[4]/span/text()",
        )
        overview.add_xpath(
            field_name="revenue",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[6]/span/text()",
        )
        overview.add_xpath(
            field_name="established_at",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[8]/span/text()",
        )
        overview.add_xpath(
            field_name="description",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/p[1]/text()",
        )
        overview.add_xpath(
            field_name="insurance_policies",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[1]/li",
        )
        overview.add_xpath(
            field_name="activities",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[2]/li",
        )
        overview.add_xpath(
            field_name="background_history",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[3]/li",
        )
        overview.add_xpath(
            field_name="mission",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/p[6]/text()",
        )
        overview.add_xpath(
            field_name="parent",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div[2]/div/a/div[1]/div[2]/p[1]/text()",
        )
        overview.add_xpath(
            field_name="parent_headquarter",
            xpath="/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div[2]/div/a/div[1]/div[2]/p[2]/text()",
        )
        item = overview.load_item()

        page = "overview"
        overview_path = Path(cfg.data_lake) / "raw" / "company_review"
        overview_path.mkdir(parents=True, exist_ok=True)
        filename = overview_path / f"{page}.jsonl"

        with open(filename, "a") as f:
            f.write(json.dumps(ItemAdapter(item).asdict(), ensure_ascii=False) + "\n")

        self.logger.debug(f"Saved file {filename}")

    def parse_review(self, response):
        review_ratings = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div/div[1]/div/div/span/text()"
        ).getall()

        review_titles = response.css("div.d-flex .align-items-center>h2::text").re(
            "\n\s*(.*)\n\s*$"
        )

        review_positions = response.xpath(
            '//span[@class="mb-10 font-12 ReviewCandidateSubtext"]/text()'
        ).re("\n\s*(.*)\n\s*$")

        review_dates = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div/div[2]/div/p/text()"
        ).re("\n\s*\n\s*-\s*(.*)\n\s*$")

        review_pros_and_cons = (
            response.css(".mb-3 .ReviewDetails .blur-text")
            .xpath("string()")
            .re("\n\s*(.*)\n\s*$")
        )
        pros = review_pros_and_cons[1::2]
        cons = review_pros_and_cons[0::2]

        page = response.url.split("/")[-2]
        review_path = Path(cfg.data_lake) / "raw" / "company_review"
        review_path.mkdir(parents=True, exist_ok=True)
        filename = review_path / f"{page}.jsonl"

        for i in range(len(review_ratings)):
            review = CompanyReviewLoader(item=CompanyReviewItem(), response=response)
            review.add_value("link", response.url)
            review.add_value("review_ratings", review_ratings[i])
            review.add_value("review_titles", review_titles[i])
            review.add_value("review_positions", review_positions[i])
            review.add_value("review_dates", review_dates[i])
            review.add_value("pros", pros[i])
            review.add_value("cons", cons[i])
            res = review.load_item()
            # res = {
            #     "link": response.url,
            #     "review_ratings": review_ratings[i],
            #     "review_titles": review_titles[i],
            #     "review_positions": review_positions[i],
            #     "review_dates": review_dates[i],
            #     "pros": pros[i],
            #     "cons": cons[i],
            # }
            with open(filename, "a") as f:
                f.write(
                    json.dumps(ItemAdapter(res).asdict(), ensure_ascii=False) + "\n"
                )

    def parse(self, response):
        anchors = response.xpath(
            "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div/@data-href"
        ).re(r"1900.com.vn/tong-quan/(.*)")
        # yield response.follow("tong-quan/" + anchors[0], callback=self.parse_overview)
        for a in anchors:
            yield response.follow("tong-quan/" + a, callback=self.parse_overview)
            yield response.follow("danh-gia-dn/" + a, callback=self.parse_review)
