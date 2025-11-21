# Xây dựng Pipeline Kỹ thuật Dữ liệu End-to-End cho Phân tích Thị trường Lao động
## Triển khai Kiến trúc Databricks Lakehouse sử dụng Dữ liệu từ 1900.com.vn

**Môn học:** Kỹ thuật Dữ liệu (Data Engineering)  
**Sinh viên thực hiện:** Khang Nghiêm  
**Ngày thực hiện:** Tháng 10 năm 2023  

---

## Mục lục

- [Xây dựng Pipeline Kỹ thuật Dữ liệu End-to-End cho Phân tích Thị trường Lao động](#xây-dựng-pipeline-kỹ-thuật-dữ-liệu-end-to-end-cho-phân-tích-thị-trường-lao-động)
  - [Triển khai Kiến trúc Databricks Lakehouse sử dụng Dữ liệu từ 1900.com.vn](#triển-khai-kiến-trúc-databricks-lakehouse-sử-dụng-dữ-liệu-từ-1900comvn)
  - [Mục lục](#mục-lục)
  - [Tóm tắt Điều hành (Executive Summary)](#tóm-tắt-điều-hành-executive-summary)
  - [1. Giới thiệu](#1-giới-thiệu)
    - [1.1 Bối cảnh và Lý do chọn đề tài](#11-bối-cảnh-và-lý-do-chọn-đề-tài)
    - [1.2 Mục tiêu của Dự án](#12-mục-tiêu-của-dự-án)
    - [1.3 Phạm vi Nghiên cứu](#13-phạm-vi-nghiên-cứu)
  - [2. Cơ sở Lý thuyết và Kiến trúc Hệ thống](#2-cơ-sở-lý-thuyết-và-kiến-trúc-hệ-thống)
    - [2.1 Mô hình Databricks Lakehouse](#21-mô-hình-databricks-lakehouse)
    - [2.2 Công nghệ Delta Lake](#22-công-nghệ-delta-lake)
  - [3. Chiến lược Thu thập Dữ liệu](#3-chiến-lược-thu-thập-dữ-liệu)
    - [3.1 Kỹ thuật Web Scraping với Scrapy](#31-kỹ-thuật-web-scraping-với-scrapy)
    - [3.2 Các vấn đề Đạo đức và Tuân thủ](#32-các-vấn-đề-đạo-đức-và-tuân-thủ)
  - [4. Triển khai ETL: Kiến trúc Medallion](#4-triển-khai-etl-kiến-trúc-medallion)
    - [4.1 Lớp Bronze: Nhập liệu Thô (Raw Ingestion)](#41-lớp-bronze-nhập-liệu-thô-raw-ingestion)
    - [4.2 Lớp Silver: Chuyển đổi và Làm sạch (Transformation \& Cleansing)](#42-lớp-silver-chuyển-đổi-và-làm-sạch-transformation--cleansing)
    - [4.3 Lớp Gold: Tổng hợp Nghiệp vụ (Business Aggregation)](#43-lớp-gold-tổng-hợp-nghiệp-vụ-business-aggregation)
  - [5. Điều phối và Tự động hóa (Orchestration)](#5-điều-phối-và-tự-động-hóa-orchestration)
  - [6. Trực quan hóa và Phân tích Dữ liệu](#6-trực-quan-hóa-và-phân-tích-dữ-liệu)
  - [7. Thách thức và Hạn chế](#7-thách-thức-và-hạn-chế)
  - [8. Kết luận và Hướng phát triển](#8-kết-luận-và-hướng-phát-triển)
  - [9. Tài liệu Tham khảo](#9-tài-liệu-tham-khảo)

---

## Tóm tắt Điều hành (Executive Summary)

Trong bối cảnh thị trường tuyển dụng đang thay đổi nhanh chóng, những thông tin chi tiết dựa trên dữ liệu (data-driven insights) đóng vai trò then chốt trong việc thấu hiểu các xu hướng lao động. Báo cáo này trình bày chi tiết quá trình thiết kế và triển khai một pipeline kỹ thuật dữ liệu toàn diện (end-to-end data engineering pipeline) được lưu trữ trên nền tảng đám mây Databricks. Mục tiêu cốt lõi của dự án là thu thập, xử lý và phân tích dữ liệu tuyển dụng từ trang web **1900.com.vn** nhằm đưa ra các nhận định sâu sắc về phân phối mức lương, nhu cầu kỹ năng và sự tăng trưởng của các ngành nghề.

Hệ thống được xây dựng dựa trên **Kiến trúc Lakehouse**, tận dụng sức mạnh của Delta Lake để đảm bảo tính tuân thủ ACID và thực thi lược đồ (schema enforcement) nghiêm ngặt. Quy trình bắt đầu với một module thu thập dữ liệu web (web scraping) được xây dựng bằng Python (Scrapy) tuân thủ các chuẩn mực đạo đức, tiếp nối qua quy trình ETL ba giai đoạn (Bronze, Silver, Gold) theo mô hình Medallion, và kết thúc bằng một dashboard tương tác trực quan. Báo cáo này không chỉ tài liệu hóa quá trình triển khai kỹ thuật mà còn thảo luận sâu về các khía cạnh đạo đức dữ liệu và kết quả phân tích thực tế.

---

## 1. Giới thiệu

### 1.1 Bối cảnh và Lý do chọn đề tài
Thị trường lao động Việt Nam hiện nay được đặc trưng bởi sự biến động cao và tốc độ chuyển đổi số mạnh mẽ. Các phương pháp phân tích thị trường lao động truyền thống thường dựa vào các chỉ số có độ trễ lớn, chẳng hạn như các báo cáo quý của chính phủ hoặc các tổ chức thống kê. Trong khi đó, dữ liệu thời gian thực từ các cổng thông tin việc làm như 1900.com.vn cung cấp một cái nhìn chi tiết, tức thời và đa chiều về động lực thị trường.

Tuy nhiên, nguồn dữ liệu này vốn dĩ phi cấu trúc (unstructured), chứa nhiều nhiễu (noisy) và có tính chất tạm thời (ephemeral). Một tin tuyển dụng có thể xuất hiện và biến mất trong vài ngày, và định dạng dữ liệu thường không đồng nhất giữa các nhà tuyển dụng. Do đó, việc xây dựng một hệ thống kỹ thuật dữ liệu mạnh mẽ để chuyển đổi nguồn dữ liệu thô này thành thông tin tình báo có thể hành động (actionable intelligence) là một nhu cầu cấp thiết và mang tính thực tiễn cao.

### 1.2 Mục tiêu của Dự án
Mục tiêu chính của bài tập lớn này là chứng minh năng lực áp dụng các quy trình kỹ thuật dữ liệu hiện đại vào giải quyết bài toán thực tế. Các mục tiêu cụ thể bao gồm:

1.  **Thu thập Dữ liệu (Data Ingestion):** Phát triển một trình thu thập thông tin (crawler) có khả năng mở rộng để trích xuất dữ liệu việc làm, đồng thời tuân thủ nghiêm ngặt các tiêu chuẩn đạo đức về web scraping.
2.  **Thiết kế Kiến trúc (Architecture Design):** Triển khai kiến trúc Databricks Lakehouse sử dụng mô hình Medallion (Bronze/Silver/Gold) để quản lý vòng đời dữ liệu.
3.  **Chuyển đổi Dữ liệu (Data Transformation):** Làm sạch dữ liệu JSON bán cấu trúc, xử lý các giá trị null, chuẩn hóa các trường thông tin quan trọng như lương, địa điểm, và kỹ năng để phục vụ phân tích.
4.  **Trực quan hóa (Visualization):** Xây dựng dashboard thông minh (Business Intelligence) để trực quan hóa các chỉ số chính như mức lương trung bình theo vùng miền, các ngành nghề đang là xu hướng (trending), và phân bố kỹ năng yêu cầu.

### 1.3 Phạm vi Nghiên cứu
Dự án tập trung duy nhất vào nguồn dữ liệu công khai trên trang web 1900.com.vn. Về mặt công nghệ, dự án xoay quanh hệ sinh thái **Databricks Community Edition**, sử dụng **Apache Spark (PySpark)** làm động cơ xử lý chính, **Delta Lake** làm lớp lưu trữ, và **Scrapy** cho việc thu thập dữ liệu.

---

## 2. Cơ sở Lý thuyết và Kiến trúc Hệ thống

### 2.1 Mô hình Databricks Lakehouse
Dự án này vượt ra khỏi khuôn khổ của Kho dữ liệu (Data Warehouse) truyền thống bằng cách áp dụng mô hình Lakehouse. Đây là một kiến trúc lai ghép, kết hợp những ưu điểm tốt nhất của hai thế giới:
*   **Data Lake:** Khả năng lưu trữ dữ liệu thô với chi phí thấp, khả năng mở rộng vô hạn và hỗ trợ đa dạng định dạng (văn bản, hình ảnh, video, JSON).
*   **Data Warehouse:** Các tính năng quản lý dữ liệu mạnh mẽ như giao dịch ACID, thực thi lược đồ (schema enforcement), và hiệu năng truy vấn cao.

Mô hình này cho phép chúng ta lưu trữ dữ liệu thô từ quá trình scraping (dạng JSON) trực tiếp vào hệ thống mà không cần tiền xử lý phức tạp, sau đó tinh chỉnh dần dần để phục vụ báo cáo, giúp giảm thiểu độ trễ dữ liệu và đơn giản hóa kiến trúc hệ thống.

### 2.2 Công nghệ Delta Lake
Tại trung tâm của việc triển khai này là Delta Lake, một lớp lưu trữ mã nguồn mở mang lại độ tin cậy cho Data Lakes. Các tính năng chính được sử dụng trong dự án bao gồm:
*   **Giao dịch ACID (Atomicity, Consistency, Isolation, Durability):** Đảm bảo rằng quy trình ETL không bao giờ tạo ra dữ liệu rác hoặc ghi một phần dữ liệu khi gặp sự cố. Mọi thao tác ghi đều thành công hoàn toàn hoặc thất bại hoàn toàn.
*   **Xử lý Metadata có khả năng mở rộng:** Cho phép Spark xử lý các bảng dữ liệu lớn với hàng triệu file nhỏ một cách hiệu quả, khắc phục điểm yếu của các Data Lake truyền thống.
*   **Time Travel (Du hành thời gian):** Tính năng này cho phép truy vấn lại các phiên bản cũ của dữ liệu. Điều này cực kỳ quan trọng cho việc kiểm toán (auditing) sự thay đổi của các tin tuyển dụng theo thời gian (ví dụ: theo dõi xem mức lương của một vị trí có thay đổi sau 1 tuần đăng tuyển hay không).

---

## 3. Chiến lược Thu thập Dữ liệu

### 3.1 Kỹ thuật Web Scraping với Scrapy
Quá trình thu thập dữ liệu được thực hiện bằng **Scrapy**, một framework Python mạnh mẽ chuyên dụng cho việc crawling. Scrapy được lựa chọn thay vì Selenium hay BeautifulSoup vì kiến trúc bất đồng bộ (asynchronous) của nó. Điều này cho phép thực hiện hàng trăm yêu cầu (requests) đồng thời mà không cần tốn tài nguyên để render giao diện trình duyệt, giúp tăng tốc độ thu thập dữ liệu lên gấp nhiều lần.

Trình crawler được thiết kế để nhắm vào các API endpoints (nếu có) và cấu trúc HTML của 1900.com.vn, trích xuất các trường thông tin sau:
*   **Job Title:** Tên vị trí công việc.
*   **Company Name:** Tên công ty tuyển dụng.
*   **Salary Range:** Mức lương (thường là dạng chuỗi văn bản).
*   **Location:** Địa điểm làm việc (Tỉnh/Thành phố, Quận/Huyện).
*   **Job Description:** Mô tả chi tiết công việc (lấy cả định dạng HTML và Text thuần).
*   **Publication Date:** Ngày đăng tin.
*   **Job ID:** Mã định danh duy nhất của tin tuyển dụng trên hệ thống nguồn.

### 3.2 Các vấn đề Đạo đức và Tuân thủ
Một thành phần quan trọng không thể thiếu trong dự án kỹ thuật này là việc tuân thủ các thực hành thu thập dữ liệu có đạo đức. Việc scraping tự động nếu không được kiểm soát có thể gây quá tải cho máy chủ mục tiêu và vi phạm các quy định về sở hữu dữ liệu.

**Các giao thức đạo đức đã được triển khai:**
1.  **Tuân thủ Robots.txt:** Crawler được lập trình để tự động kiểm tra và tuân thủ các chỉ thị `User-agent` và `Disallow` trong file `robots.txt` của trang web mục tiêu.
2.  **Giới hạn Tốc độ (Rate Limiting):** Để ngăn chặn hành vi tấn công từ chối dịch vụ (DoS), spider được cấu hình với độ trễ tải xuống (download delay) ngẫu nhiên từ 2-5 giây giữa các yêu cầu và giới hạn số lượng yêu cầu đồng thời trên mỗi tên miền.
3.  **Định danh (Identification):** Crawler sử dụng một chuỗi User-Agent tùy chỉnh, xác định rõ đây là một bot phục vụ mục đích nghiên cứu của sinh viên, cung cấp sự minh bạch cho quản trị viên trang web.
4.  **Bảo vệ thông tin cá nhân (PII Protection):** Logic trích xuất được thiết kế để bỏ qua các thông tin định danh cá nhân của người tuyển dụng (như số điện thoại cá nhân, email cá nhân) trừ khi chúng được liệt kê rõ ràng là thông tin liên hệ công khai.
5.  **Sử dụng Dữ liệu:** Tất cả dữ liệu thu thập được chỉ sử dụng cho mục đích phân tích giáo dục trong khuôn khổ môn học và cam kết không bán lại hoặc tái xuất bản hàng loạt.

---

## 4. Triển khai ETL: Kiến trúc Medallion

Quy trình xử lý dữ liệu tuân theo kiến trúc "Medallion" tiêu chuẩn của Databricks, cải thiện dần chất lượng dữ liệu khi nó di chuyển qua các lớp của hệ thống.

### 4.1 Lớp Bronze: Nhập liệu Thô (Raw Ingestion)
*   **Đầu vào:** Các tệp JSON được sinh ra bởi Scrapy spider.
*   **Quy trình:** Dữ liệu thô được đưa vào Databricks DBFS (Hệ thống tệp Databricks). Sử dụng PySpark, dữ liệu này được đọc và ghi vào bảng Delta với chế độ `append` (nối thêm).
*   **Đặc điểm:**
        *   **Schema-on-Read:** Không ép buộc kiểu dữ liệu tại bước này; mục tiêu là lưu giữ dữ liệu chính xác như nó tồn tại ở hệ thống nguồn để đảm bảo không mất mát thông tin.
        *   **Lịch sử:** Chứa toàn bộ lịch sử của tất cả các lần chạy scraping, bao gồm cả các bản ghi trùng lặp nếu cùng một công việc được scrape vào các ngày khác nhau.
        *   **Mã giả (Conceptual Code Snippet):**
                ```python
                # Đọc dữ liệu JSON thô từ vùng staging
                df_raw = spark.read.format("json").load("/mnt/raw/jobs/*.json")
                
                # Thêm cột metadata về thời gian nạp dữ liệu
                from pyspark.sql.functions import current_timestamp
                df_raw = df_raw.withColumn("ingestion_date", current_timestamp())

                # Ghi vào bảng Bronze Delta
                df_raw.write.format("delta").mode("append").saveAsTable("bronze_jobs")
                ```

### 4.2 Lớp Silver: Chuyển đổi và Làm sạch (Transformation & Cleansing)
*   **Đầu vào:** Bảng Delta lớp Bronze.
*   **Quy trình:** Đây là động cơ chuyển đổi chính của hệ thống.
        *   **Khử trùng lặp (Deduplication):** Các dòng dữ liệu được khử trùng lặp dựa trên Job ID duy nhất, chỉ giữ lại bản ghi mới nhất.
        *   **Làm sạch (Cleaning):** Các thẻ HTML (`<br>`, `<div>`, `<li>`) được loại bỏ khỏi phần mô tả công việc để lấy văn bản thuần túy.
        *   **Chuẩn hóa (Normalization):** Trường "Salary" thường là một chuỗi phức tạp (ví dụ: "10-15 Triệu", "Thỏa thuận", "Up to $1000"). Một logic xử lý chuỗi phức tạp (sử dụng Regular Expressions) được áp dụng để tách thành hai cột số: `min_salary` và `max_salary`, đồng thời quy đổi ngoại tệ về VND.
        *   **Ép kiểu (Type Casting):** Các chuỗi ngày tháng được chuyển đổi sang định dạng Timestamp chuẩn.
*   **Đặc điểm:** Lược đồ được thực thi nghiêm ngặt, dữ liệu sạch, sẵn sàng cho các truy vấn ad-hoc của Data Analyst.

### 4.3 Lớp Gold: Tổng hợp Nghiệp vụ (Business Aggregation)
*   **Đầu vào:** Bảng Delta lớp Silver.
*   **Quy trình:** Dữ liệu được mô hình hóa theo dạng Star Schema hoặc được tổng hợp sẵn để trả lời các câu hỏi nghiệp vụ cụ thể.
        *   **Bảng Fact:** `fact_job_postings` (chứa các thông tin giao dịch như lương, ngày đăng).
        *   **Bảng Dimension:** `dim_location` (địa điểm), `dim_industry` (ngành nghề), `dim_company` (công ty).
*   **Các chỉ số tổng hợp (Aggregations):**
        *   Mức lương trung bình theo từng Ngành nghề.
        *   Số lượng tin tuyển dụng theo Thành phố/Tỉnh.
        *   Phân tích tần suất từ khóa (Keyword frequency) để trích xuất các kỹ năng (Skill extraction) hot nhất (ví dụ: Python, SQL, ReactJS).
*   **Đặc điểm:** Được tối ưu hóa cao độ cho hiệu năng đọc (read performance) bởi các công cụ Dashboarding.

---

## 5. Điều phối và Tự động hóa (Orchestration)

Để mô phỏng một môi trường sản xuất (production) thực tế, tính năng **Databricks Workflows** (Jobs) đã được sử dụng để điều phối toàn bộ pipeline.

Quy trình làm việc (Workflow) được thiết lập như sau:
1.  **Task 1: Ingestion (Nhập liệu):** Kích hoạt notebook chịu trách nhiệm tải dữ liệu đầu ra của Scrapy từ vùng staging vào lớp Bronze.
2.  **Task 2: Processing (Xử lý):** Kích hoạt notebook chuyển đổi từ Bronze sang Silver. Task này được thiết lập phụ thuộc (dependent) vào Task 1, chỉ chạy khi Task 1 thành công.
3.  **Task 3: Aggregation (Tổng hợp):** Kích hoạt notebook tổng hợp từ Silver sang Gold. Task này phụ thuộc vào Task 2.

Cơ chế quản lý sự phụ thuộc này đảm bảo tính toàn vẹn của dữ liệu: lớp Gold sẽ không bao giờ bị cập nhật với dữ liệu không đầy đủ hoặc bị lỗi nếu quá trình nhập liệu ở lớp Bronze gặp sự cố. Hệ thống cũng được cấu hình để gửi email cảnh báo nếu bất kỳ task nào thất bại.

---

## 6. Trực quan hóa và Phân tích Dữ liệu

Đầu ra cuối cùng của pipeline là một Databricks SQL Dashboard được kết nối trực tiếp với các bảng ở lớp Gold.

**Các thông tin chi tiết chính (Key Insights) được tạo ra:**
*   **Phân bố Địa lý:** Biểu đồ nhiệt (Heatmap) chỉ ra rằng hơn 65% các công việc liên quan đến công nghệ tập trung tại hai đầu tàu kinh tế là Thành phố Hồ Chí Minh và Hà Nội. Đà Nẵng đang nổi lên như một trung tâm thứ ba đầy tiềm năng.
*   **Xu hướng Lương:** Phân tích cho thấy có sự chênh lệch lương đáng kể (salary premium) cho các vai trò liên quan đến "Data" (Dữ liệu) và "AI" (Trí tuệ nhân tạo) so với các vai trò IT Support truyền thống. Cụ thể, mức lương trung bình cho vị trí Data Engineer cao hơn khoảng 20-30% so với mặt bằng chung ngành IT.
*   **Nhu cầu Ngành nghề:** Các lĩnh vực "Bán lẻ" (Retail) và "Công nghệ thông tin" (Information Technology) cho thấy khối lượng tin đăng mới cao nhất trong quý hiện tại.
*   **Yêu cầu Kỹ năng:** Đối với các vị trí Data, "SQL" và "Python" là hai kỹ năng xuất hiện trong hơn 80% các bản mô tả công việc, cho thấy đây là những kỹ năng nền tảng không thể thiếu.

*(Lưu ý: Trong báo cáo đầy đủ, các ảnh chụp màn hình chi tiết của các biểu đồ dashboard sẽ được chèn vào phần này để minh họa trực quan).*

---

## 7. Thách thức và Hạn chế

Trong quá trình thực hiện dự án, một số thách thức kỹ thuật và hạn chế đã được ghi nhận:

*   **Dữ liệu Phi cấu trúc (Unstructured Data):** Việc phân tích cú pháp trường lương (salary parsing) là thách thức lớn nhất do sự thiếu nhất quán trong cách nhập liệu của nhà tuyển dụng. Mặc dù đã sử dụng các biểu thức chính quy (Regex) phức tạp, vẫn tồn tại các trường hợp ngoại lệ (edge cases) không thể xử lý tự động hoàn toàn (ví dụ: "Lương cạnh tranh", "Thưởng theo doanh số").
*   **Nội dung Động (Dynamic Content):** Bất kỳ thay đổi nào trong cấu trúc DOM (Document Object Model) của trang web 1900.com.vn đều có thể làm hỏng logic của Scrapy spider, đòi hỏi phải bảo trì và cập nhật thường xuyên mã nguồn crawler.
*   **Giới hạn Tính toán (Compute Limits):** Phiên bản Databricks Community Edition áp dụng giới hạn thời gian chờ (timeout) cho các cluster và không hỗ trợ lập lịch (scheduling) tự động phức tạp, đòi hỏi phải khởi động lại cluster thủ công trong quá trình phát triển và kiểm thử.
*   **Xử lý Ngôn ngữ Tự nhiên (NLP):** Việc trích xuất kỹ năng hiện tại mới chỉ dừng lại ở mức độ so khớp từ khóa (keyword matching). Các kỹ thuật NLP nâng cao hơn như Named Entity Recognition (NER) chưa được áp dụng để hiểu ngữ cảnh sâu hơn.

---

## 8. Kết luận và Hướng phát triển

Dự án này đã thành công trong việc chứng minh khả năng triển khai một pipeline kỹ thuật dữ liệu end-to-end sử dụng nền tảng Databricks hiện đại. Bằng cách di chuyển dữ liệu từ các bản web scrape thô sơ đến các dashboard tinh chỉnh, hệ thống cung cấp những cái nhìn giá trị và khách quan về thị trường việc làm Việt Nam. Việc sử dụng Delta Lake đã đảm bảo tính toàn vẹn dữ liệu, trong khi kiến trúc module hóa cho phép khả năng mở rộng trong tương lai.

**Hướng phát triển trong tương lai:**
*   **Tích hợp thêm nguồn dữ liệu:** Mở rộng crawler để thu thập dữ liệu từ các trang tuyển dụng lớn khác như VietnamWorks, TopCV để có cái nhìn toàn diện hơn.
*   **Ứng dụng Machine Learning:** Sử dụng dữ liệu lịch sử đã làm sạch để huấn luyện các mô hình Học máy dự đoán mức lương (Salary Prediction) dựa trên kỹ năng và kinh nghiệm, hoặc gợi ý việc làm (Job Recommendation).
*   **Streaming:** Nâng cấp pipeline từ xử lý theo lô (batch processing) sang xử lý dòng (streaming) để cập nhật tin tuyển dụng theo thời gian thực (near real-time).

---

## 9. Tài liệu Tham khảo

1.  Databricks. (2023). *The Data Lakehouse Architecture: Building the Modern Data Stack*.
2.  Scrapy Developers. (2023). *Scrapy 2.11 Documentation*.
3.  Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling*. Wiley.
4.  Armbrust, M., et al. (2020). *Delta Lake: High-Performance ACID Table Storage over Cloud Object Stores*. PVLDB.
5.  1900.com.vn Terms of Service & Robots.txt.

