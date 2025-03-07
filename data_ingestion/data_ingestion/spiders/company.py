import json
import os
import sys
import scrapy
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__ + "../../../..")))
from config import cfg


class CompanySpider(scrapy.Spider):
    name = "company"
    allowed_domains = ["1900.com.vn"]
    start_urls = [f"https://1900.com.vn/cong-ty?page={i}" for i in range(1, 200)]

    def parse_overview(self, response):
        website = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[1]/a/@href"
        ).get()
        phone_number = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[3]/span/text()"
        ).get()
        department = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[5]/a/@href"
        ).get()
        business_type = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[7]/span/text()"
        ).get()
        headquarter = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[2]/span/text()"
        ).get()
        scale = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[4]/span/text()"
        ).get()
        revenue = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[6]/span/text()"
        ).get()
        established_at = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[8]/span/text()"
        ).get()

        description = (
            response.xpath("/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/p[1]")
            .xpath("string()")
            .get()
        )

        insurance_policies = (
            response.xpath(
                "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[1]/li"
            )
            .xpath("string()")
            .getall()
        )

        activities = (
            response.xpath(
                "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[2]/li"
            )
            .xpath("string()")
            .getall()
        )

        background_history = (
            response.xpath(
                "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[3]/li"
            )
            .xpath("string()")
            .getall()
        )
        mission = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/p[6]/text()"
        ).get()

        parent = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div[2]/div/a/div[1]/div[2]/p[1]/text()"
        ).get()

        parent_headquarter = response.xpath(
            "/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div[2]/div/a/div[1]/div[2]/p[2]/text()"
        ).get()

        page = "overview"
        overview_path = Path(cfg.data_lake) / "raw" / "company_review"
        overview_path.mkdir(parents=True, exist_ok=True)
        filename = overview_path / f"{page}.json"
        res = {
            "link": response.url,
            "website": website,
            "phone_number": phone_number,
            "department": department,
            "business_type": business_type,
            "headquarter": headquarter,
            "scale": scale,
            "revenue": revenue,
            "established_at": established_at,
            "description": description,
            "insurance_policies": insurance_policies,
            "activities": activities,
            "background_history": background_history,
            "mission": mission,
            "parent": parent,
            "parent_headquarter": parent_headquarter,
        }
        with open(filename, "a") as f:
            f.write(json.dumps(res, ensure_ascii=False) + ",\n")

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
        filename = review_path / f"{page}.json"

        for i in range(len(review_ratings)):
            res = {
                "link": response.url,
                "review_ratings": review_ratings[i],
                "review_titles": review_titles[i],
                "review_positions": review_positions[i],
                "review_dates": review_dates[i],
                "pros": pros[i],
                "cons": cons[i],
            }
            with open(filename, "a") as f:
                f.write(json.dumps(res, ensure_ascii=False) + ",\n")

    def parse(self, response):
        anchors = response.xpath(
            "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div/@data-href"
        ).re(r"1900.com.vn/tong-quan/(.*)")
        for a in anchors:
            yield response.follow("tong-quan/" + a, callback=self.parse_overview)
            yield response.follow("danh-gia-dn/" + a, callback=self.parse_review)
