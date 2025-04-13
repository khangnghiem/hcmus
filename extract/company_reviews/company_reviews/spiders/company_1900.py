import sys
import scrapy
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[4]))
from config import cfg
from company_reviews.items import (
    CompanyItem,
    CompanyLoader,
    CompanyOverviewItem,
    CompanyOverviewLoader,
    CompanyReviewItem,
    CompanyReviewLoader,
)


class Company1900Spider(scrapy.Spider):
    name = "company_1900"
    allowed_domains = ["1900.com.vn"]
    start_urls = ["https://1900.com.vn/cong-ty?page=1"]
    output_folder = f"{cfg.DATA_LAKE}/extract/company_review/"
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
        try:
            pages = int(
                response.xpath(
                    "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div[21]/div/nav/ul/li[8]/a/text()"
                ).get()
            )
        except (ValueError, TypeError):
            self.logger.error("Failed to extract the number of pages.")

        for i in range(1, pages + 1):
            yield response.follow(
                f"https://1900.com.vn/cong-ty?page={i}", callback=self.parse_page
            )

    def parse_page(self, response):
        links = response.xpath(
            "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div/@data-href"
        ).getall()
        names = response.xpath(
            "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div/div/div[1]/div/div/div[2]/a/h2/text()"
        ).getall()
        locations = response.xpath(
            "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div/div/div[3]/span[2]/text()"
        ).getall()
        departments = response.xpath(
            "/html/body/div[1]/main/div[1]/form/div[2]/div[2]/div[2]/div/div/div[5]/span[2]/text()"
        ).getall()

        for i in range(len(links)):
            company = CompanyLoader(item=CompanyItem(), response=response)
            company.add_value("link", links[i])
            company.add_value("name", names[i])
            company.add_value("location", locations[i])
            company.add_value("department", departments[i])
            yield company.load_item()

            a = links[i].split("/")[-1]
            yield response.follow("tong-quan/" + a, callback=self.parse_overview)
            yield response.follow("danh-gia-dn/" + a, callback=self.parse_review)

    def parse_overview(self, response):
        overview = CompanyOverviewLoader(item=CompanyOverviewItem(), response=response)
        overview_xpaths = {
            "website": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[1]/a/@href",
            "phone_number": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[3]/span/text()",
            "department": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[5]/a/text()",
            "business_type": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[7]/span/text()",
            "headquarter": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[2]/span/text()",
            "scale": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[4]/span/text()",
            "revenue": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[6]/span/text()",
            "established_at": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/ul/li[8]/span/text()",
            "description": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/p[1]/text()",
            "insurance_policies": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[1]/li",
            "activities": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[2]/li",
            "background_history": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/ul[3]/li",
            "mission": "/html/body/div[1]/main/div/div[2]/div[1]/div[1]/div/p[6]/text()",
            "parent": "/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div[2]/div/a/div[1]/div[2]/p[1]/text()",
            "parent_headquarter": "/html/body/div[1]/main/div/div[2]/div[1]/div[2]/div[2]/div/a/div[1]/div[2]/p[2]/text()",
        }

        for field_name, xpath in overview_xpaths.items():
            overview.add_value("link", response.url)
            overview.add_xpath(field_name=field_name, xpath=xpath)
        yield overview.load_item()

    def parse_review(self, response):
        review_ratings = response.css(
            "span.ratingNumber.greenColor.font-weight-bold.mr-5::text"
        ).getall()

        review_titles = response.css("div.d-flex .align-items-center>h2::text").re(
            r"\n\s*(.*)\n\s*$"
        )

        review_positions = response.xpath(
            '//span[@class="mb-10 font-12 ReviewCandidateSubtext"]/text()'
        ).re(r"\n\s*(.*)\n\s*$")

        review_dates = response.css("p.mb-3.font-14.ReviewCandidateSubtext").re(
            r"-\s*(\d{2}/\d{2}/\d{4})"
        )

        review_pros_and_cons = response.css(
            ".mb-3 .ReviewDetails .blur-text::text"
        ).getall()
        # pros = response.xpath(
        #     "/html/body/div[1]/main/div/div[2]/div[1]/div[3]/div/div[2]/div/div[3]/div[1]/text()"
        # )
        # cons = response.xpath(
        #     "/html/body/div[1]/main/div/div[2]/div[1]/div[3]/div/div[2]/div/div[2]/div[2]/text()"
        #     "/html/body/div[1]/main/div/div[2]/div[1]/div[3]/div[2]/div[2]/div/div[3]/div[2]/text()"
        #     "/html/body/div[1]/main/div/div[2]/div[1]/div[3]/div[11]/div[2]/div/div[3]/div[2]/text()"
        # )
        pros = review_pros_and_cons[1::2]
        cons = review_pros_and_cons[0::2]

        for i in range(len(review_ratings)):
            review = CompanyReviewLoader(item=CompanyReviewItem(), response=response)
            review.add_value("link", response.url)
            review.add_value("review_rating", review_ratings[i])
            review.add_value("review_title", review_titles[i])
            review.add_value(
                "review_position",
                review_positions[i] if i < len(review_positions) else None,
            )
            review.add_value(
                "review_date", review_dates[i] if i < len(review_dates) else None
            )
            review.add_value("pros", pros[i])
            review.add_value("cons", cons[i])
            rev = review.load_item()
            yield rev

        if len(review_ratings) == 20:
            next_page = response.url.split("page=")
            next_page = (
                f"{next_page[0]}page={int(next_page[1]) + 1}"
                if len(next_page) > 1
                else f"{response.url}?page=2"
            )
            yield response.follow(next_page, callback=self.parse_review)
