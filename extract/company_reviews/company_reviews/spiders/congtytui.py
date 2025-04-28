import sys
import scrapy
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[4]))
from config import cfg
from ..items import (
    CompanyItem,
    CompanyLoader,
    CompanyReviewItem,
    CompanyReviewLoader,
)


class CongtytuiSpider(scrapy.Spider):
    name = "congtytui"
    allowed_domains = ["congtytui1.com"]
    start_urls = ["https://congtytui1.com/?page=1"]
    output_folder = f"{cfg.DATA_LAKE}/public/extract/company_reviews/"
    file_format = "json"

    custom_settings = {
        "FEEDS": {
            f"{output_folder}/{cfg.today}_%(name)s_list.{file_format}": {
                "format": f"{file_format}",
                "overwrite": True,
                "item_classes": ["company_reviews.items.CompanyItem"],
            },
            f"{output_folder}/{cfg.today}_%(name)s_overview.{file_format}": {
                "format": f"{file_format}",
                "overwrite": True,
                "item_classes": ["company_reviews.items.CompanyOverviewItem"],
            },
            f"{output_folder}/{cfg.today}_%(name)s_review.{file_format}": {
                "format": f"{file_format}",
                "overwrite": True,
                "item_classes": ["company_reviews.items.CompanyReviewItem"],
            },
        },
    }

    def parse(self, response):
        last_page = response.xpath(
            "/html/body/main/div[1]/div/div[1]/section/div[2]/div/div/div[2]/div/nav/ul/li[10]/a/text()"
        ).get()
        if last_page:
            last_page = int(last_page)
        else:
            last_page = 1

        for i in range(1, last_page + 1):
            yield response.follow(
                f"https://congtytui1.com/?page={i}", callback=self.parse_page
            )

    def parse_page(self, response):
        links = response.xpath(
            "/html/body/main/div[1]/div/div[1]/section/div[2]/div/div/div[1]/div/div/h3/a/@href"
        ).getall()
        names = response.xpath(
            "/html/body/main/div[1]/div/div[1]/section/div[2]/div/div/div[1]/div/div/h3/a/text()"
        ).getall()
        locations = response.xpath(
            "/html/body/main/div[1]/div/div[1]/section/div[2]/div/div/div[1]/div/div/div[3]/text()"
        ).getall()[1::2]
        departments = response.xpath(
            "/html/body/main/div[1]/div/div[1]/section/div[2]/div/div/div[1]/div/div/div[2]/div[1]/text()"
        ).getall()[1::2]

        scales = response.xpath(
            "/html/body/main/div[1]/div/div[1]/section/div[2]/div/div/div[1]/div/div/div[2]/div[2]/text()"
        ).getall()[1::2]

        for i in range(len(links)):
            company = CompanyLoader(item=CompanyItem(), response=response)
            company.add_value("link", links[i])
            company.add_value("name", names[i])
            company.add_value("location", locations[i])
            company.add_value("department", departments[i])
            company.add_value("scale", scales[i])
            yield company.load_item()

            a = links[i].split("/")[-1]
            yield response.follow(
                f"companies/{a}?page=1",
                callback=self.parse_review_page,
                meta={"link": links[i]},
            )

    def parse_review_page(self, response):
        last_page = response.xpath(
            "/html/body/main/div[3]/div/div[1]/section/div[4]/div/nav/ul/li[10]/a/text()"
        ).get()
        if last_page and last_page.isdigit():
            last_page = int(last_page)
        else:
            last_page = 1
        for i in range(1, last_page + 1):
            yield response.follow(
                f"{response.url}&page={i}",
                callback=self.parse_review,
                meta={"link": response.meta["link"]},
            )

    def parse_review(self, response):
        review_ratings = response.xpath(
            "/html/body/main/div[3]/div/div[1]/section/div[3]/div/div[1]/div[2]/div/div/@style"
        ).re(r"width:\s*(\d+%)")

        review_ratings = [
            {"0%": "5.0", "20%": "4.0", "40%": "3.0", "60%": "2.0", "80%": "1.0"}.get(
                rating.strip()
            )
            for rating in review_ratings
        ]

        review_titles = response.xpath(
            "/html/body/main/div[3]/div/div[1]/section/div[3]/div/div[2]/p/text()"
        ).getall()

        for i in range(len(review_ratings)):
            review = CompanyReviewLoader(item=CompanyReviewItem(), response=response)
            review.add_value("link", response.meta["link"])
            review.add_value(
                "review_rating", review_ratings[i] if i < len(review_ratings) else None
            )
            review.add_value(
                "review_title", review_titles[i] if i < len(review_titles) else None
            )
            rev = review.load_item()
            yield rev
