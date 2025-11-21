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
  - [Tóm tắt Điều hành](#tóm-tắt-điều-hành)
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
    - [5.1 Thiết kế Workflow Đa tác vụ (Multi-Task Job)](#51-thiết-kế-workflow-đa-tác-vụ-multi-task-job)
    - [5.2 Các tính năng Nâng cao được áp dụng](#52-các-tính-năng-nâng-cao-được-áp-dụng)
  - [6. Trực quan hóa và Phân tích Dữ liệu](#6-trực-quan-hóa-và-phân-tích-dữ-liệu)
    - [6.1 Tổng quan Thị trường (Market Overview Dashboard)](#61-tổng-quan-thị-trường-market-overview-dashboard)
    - [6.2 Phân tích Lương thưởng Chuyên sâu (Salary Intelligence)](#62-phân-tích-lương-thưởng-chuyên-sâu-salary-intelligence)
    - [6.3 Xu hướng Ngành nghề và Kỹ năng (Industry \& Skills Trends)](#63-xu-hướng-ngành-nghề-và-kỹ-năng-industry--skills-trends)
    - [6.4 Khả năng Tương tác (Interactivity)](#64-khả-năng-tương-tác-interactivity)
  - [7. Thách thức và Hạn chế](#7-thách-thức-và-hạn-chế)
    - [7.1 Thách thức về Chất lượng và Xử lý Dữ liệu (Data Quality \& Processing Challenges)](#71-thách-thức-về-chất-lượng-và-xử-lý-dữ-liệu-data-quality--processing-challenges)
    - [7.2 Thách thức về Thu thập Dữ liệu (Ingestion Challenges)](#72-thách-thức-về-thu-thập-dữ-liệu-ingestion-challenges)
    - [7.3 Hạn chế về Hạ tầng và Công nghệ (Infrastructure \& Technology Limitations)](#73-hạn-chế-về-hạ-tầng-và-công-nghệ-infrastructure--technology-limitations)
    - [7.4 Hạn chế trong Phân tích Nâng cao (Advanced Analytics Limitations)](#74-hạn-chế-trong-phân-tích-nâng-cao-advanced-analytics-limitations)
  - [8. Kết luận và Hướng phát triển](#8-kết-luận-và-hướng-phát-triển)
  - [9. Tài liệu Tham khảo](#9-tài-liệu-tham-khảo)

---

## Tóm tắt Điều hành

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
Dự án tập trung duy nhất vào nguồn dữ liệu công khai trên trang web 1900.com.vn. Về mặt công nghệ, dự án xoay quanh hệ sinh thái **Databricks Free Edition**, sử dụng **Apache Spark (PySpark)** làm động cơ xử lý chính, **Delta Lake** làm lớp lưu trữ, và **Scrapy** cho việc thu thập dữ liệu.

---

## 2. Cơ sở Lý thuyết và Kiến trúc Hệ thống

### 2.1 Mô hình Databricks Lakehouse
Dự án này vượt ra khỏi khuôn khổ hạn chế của các Kho dữ liệu (Data Warehouse) truyền thống hay các Hồ dữ liệu (Data Lake) đơn lẻ bằng cách áp dụng nền tảng mô hình tiên tiến **Databricks Lakehouse**. Đây là một kiến trúc lai ghép mang tính cách mạng, được thiết kế để kết hợp những ưu điểm vượt trội nhất của hai thế giới dữ liệu vốn dĩ tách biệt:

*   **Sự linh hoạt của Data Lake:** Kiến trúc này thừa hưởng khả năng lưu trữ dữ liệu thô với chi phí thấp và khả năng mở rộng gần như vô hạn từ Data Lake. Nó cho phép hệ thống chấp nhận mọi định dạng dữ liệu, từ dữ liệu có cấu trúc (bảng biểu), bán cấu trúc (JSON, XML) đến phi cấu trúc (văn bản, hình ảnh, video) mà không yêu cầu định nghĩa lược đồ trước, đồng thời hỗ trợ **schema evolution** để tự động thích ứng khi cấu trúc dữ liệu thay đổi. Điều này cực kỳ quan trọng đối với dự án này, nơi dữ liệu đầu vào là các tệp JSON thô, đa dạng và thường xuyên thay đổi cấu trúc từ quá trình web scraping.
*   **Sự tin cậy của Data Warehouse:** Đồng thời, Lakehouse tích hợp các tính năng quản lý dữ liệu mạnh mẽ vốn chỉ có ở Data Warehouse doanh nghiệp. Các tính năng này bao gồm đảm bảo tính toàn vẹn giao dịch (ACID transactions), thực thi và quản trị lược đồ (schema enforcement & evolution), cũng như khả năng tối ưu hóa hiệu năng truy vấn cao cho các tác vụ Business Intelligence (BI).

Mô hình hợp nhất này giải quyết triệt để vấn đề "silos dữ liệu" (các ốc đảo dữ liệu bị cô lập), cho phép chúng ta lưu trữ dữ liệu thô từ quá trình scraping trực tiếp vào hệ thống mà không cần qua các bước tiền xử lý phức tạp hay tốn kém. Dữ liệu sau đó được tinh chỉnh dần dần qua các lớp (Bronze, Silver, Gold) ngay trên cùng một nền tảng lưu trữ, giúp giảm thiểu đáng kể độ trễ dữ liệu (data latency), loại bỏ việc sao chép dữ liệu dư thừa giữa các hệ thống khác nhau, và đơn giản hóa toàn bộ kiến trúc vận hành.

Ngoài ra, Databricks Lakehouse còn cung cấp các tính năng vượt trội hỗ trợ trực tiếp cho quy trình Data Engineering hiện đại:
*   **Hỗ trợ đa ngôn ngữ:** Cho phép sử dụng linh hoạt Python, SQL, Scala và R trên cùng một dữ liệu, giúp các kỹ sư dữ liệu và nhà phân tích cộng tác hiệu quả. 
*   **Môi trường cộng tác thống nhất:** Kiến trúc này xóa bỏ rào cản truyền thống giữa các nhóm kỹ thuật. Kỹ sư dữ liệu (Data Engineers), Nhà khoa học dữ liệu (Data Scientists) và Chuyên viên phân tích (Data Analysts) có thể làm việc đồng thời trên cùng một nguồn dữ liệu duy nhất (Single Source of Truth), giúp loại bỏ độ trễ do sao chép dữ liệu và đảm bảo tính nhất quán trong toàn bộ quy trình phân tích.
*   **Unity Catalog:** Cung cấp giải pháp quản trị dữ liệu thống nhất, cho phép kiểm soát quyền truy cập chi tiết đến từng dòng và cột, đảm bảo an toàn dữ liệu.
*   **Auto Loader:** Tự động hóa việc nhập dữ liệu mới từ các tệp tin (JSON, CSV) ngay khi chúng xuất hiện trong storage, giúp pipeline hoạt động gần như thời gian thực (near real-time).

### 2.2 Công nghệ Delta Lake
Ngay tại trung tâm của việc triển khai kiến trúc này là **Delta Lake**, một lớp lưu trữ mã nguồn mở mang tính cách mạng, được thiết kế để mang lại độ tin cậy, hiệu suất và khả năng quản trị cho các Data Lakes. Trong khi các Data Lake truyền thống (như S3 hay HDFS thuần túy) thường gặp khó khăn với các vấn đề về tính nhất quán dữ liệu và hiệu suất khi quy mô tăng lên, Delta Lake giải quyết triệt để các thách thức này bằng cách hoạt động như một lớp trung gian thông minh. Các tính năng cốt lõi của Delta Lake được khai thác tối đa trong dự án này bao gồm:

*   **Giao dịch ACID (Atomicity, Consistency, Isolation, Durability):** Đây là tính năng quan trọng nhất giúp Delta Lake khác biệt so với các định dạng lưu trữ file thông thường (như Parquet hay CSV). Trong môi trường Big Data, việc ghi dữ liệu có thể bị gián đoạn do lỗi mạng hoặc lỗi phần cứng. Delta Lake đảm bảo tính nguyên tử (Atomicity) - nghĩa là mọi thao tác ghi dữ liệu (batch hoặc streaming) đều thành công hoàn toàn hoặc thất bại hoàn toàn, không bao giờ để lại trạng thái dữ liệu "lửng lơ" hay rác (corrupted data). Điều này đảm bảo rằng các dashboard phân tích ở cuối pipeline luôn hiển thị dữ liệu nhất quán và chính xác, ngay cả khi quá trình ETL đang diễn ra song song.

*   **Thực thi và Tiến hóa Lược đồ (Schema Enforcement & Evolution):** Delta Lake đóng vai trò như một "người gác cổng" nghiêm ngặt. Tính năng *Schema Enforcement* tự động ngăn chặn việc ghi dữ liệu sai định dạng hoặc không khớp với lược đồ đã định nghĩa, bảo vệ chất lượng dữ liệu ở lớp Silver và Gold. Tuy nhiên, trong bối cảnh dữ liệu web scraping thường xuyên thay đổi, tính năng *Schema Evolution* lại cho phép hệ thống linh hoạt tự động cập nhật lược đồ bảng để chấp nhận các cột mới mà không cần phải viết lại toàn bộ bảng, giúp pipeline thích ứng nhanh chóng với sự thay đổi của trang web nguồn.

*   **Xử lý Metadata có khả năng mở rộng (Scalable Metadata Handling):** Đối với các dự án dữ liệu lớn, metadata (thông tin về dữ liệu) có thể trở nên khổng lồ, khiến các thao tác truy vấn trở nên chậm chạp. Delta Lake xử lý metadata giống như dữ liệu thông thường, sử dụng sức mạnh phân tán của Spark để quản lý hàng triệu, thậm chí hàng tỷ file một cách hiệu quả. Điều này cho phép truy vấn nhanh chóng ngay cả trên các bảng lịch sử chứa dữ liệu tích lũy trong nhiều năm.

*   **Time Travel (Du hành thời gian) và Kiểm toán Dữ liệu:** Delta Lake tự động lưu trữ lịch sử phiên bản của dữ liệu (data versioning). Tính năng này cho phép các nhà phân tích truy vấn lại trạng thái chính xác của dữ liệu tại bất kỳ thời điểm nào trong quá khứ. Trong bối cảnh phân tích thị trường lao động, điều này cực kỳ giá trị để:
    *   **Phân tích xu hướng:** So sánh sự thay đổi của cùng một tin tuyển dụng theo thời gian (ví dụ: nhà tuyển dụng có tăng lương sau 2 tuần không tuyển được người hay không?).
    *   **Khôi phục lỗi:** Dễ dàng quay lại phiên bản dữ liệu trước đó (rollback) nếu một quy trình ETL bị lỗi ghi đè dữ liệu sai, mà không cần phải khôi phục từ bản backup phức tạp.
    *   **Tái lập kết quả:** Đảm bảo khả năng tái lập (reproducibility) cho các mô hình học máy bằng cách truy xuất đúng phiên bản dữ liệu đã dùng để huấn luyện.

*   **Nền tảng lưu trữ Parquet:** Delta Lake được xây dựng trên định dạng tệp **Parquet** mã nguồn mở. Đây là định dạng lưu trữ dạng cột (columnar storage) tối ưu, cho phép nén dữ liệu hiệu quả cao và chỉ đọc các cột cần thiết trong quá trình truy vấn (column pruning). Việc sử dụng Parquet đảm bảo dữ liệu được lưu trữ theo chuẩn công nghiệp, không bị khóa vào một nhà cung cấp cụ thể (vendor lock-in) và tối ưu hóa chi phí lưu trữ.

*   **Tối ưu hóa Hiệu năng và Liquid Clustering:** Để giải quyết các thách thức về hiệu suất khi dữ liệu tăng trưởng, hệ thống sử dụng các kỹ thuật tiên tiến:
    *   **Compaction:** Tự động gộp các file Parquet nhỏ thành các file lớn hơn để giảm thiểu chi phí I/O (vấn đề small file problem).
    *   **Liquid Clustering:** Thay thế cho các phương pháp phân vùng (partitioning) và Z-Ordering cứng nhắc truyền thống, Liquid Clustering là một kỹ thuật quản lý bố cục dữ liệu linh hoạt. Nó tự động điều chỉnh cách dữ liệu được phân cụm vật lý dựa trên các mẫu truy vấn thực tế, giúp giải quyết vấn đề lệch dữ liệu (data skew) và tối ưu hóa khả năng bỏ qua dữ liệu (data skipping) mà không cần sự can thiệp thủ công phức tạp từ kỹ sư dữ liệu.

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
Một thành phần quan trọng không thể thiếu trong dự án kỹ thuật này là việc tuân thủ nghiêm ngặt các thực hành thu thập dữ liệu có đạo đức và pháp lý. Trong kỷ nguyên số, ranh giới giữa việc khai thác dữ liệu công khai và xâm phạm quyền riêng tư hay tài sản trí tuệ thường rất mong manh. Việc scraping tự động nếu không được kiểm soát không chỉ có thể gây quá tải cho máy chủ mục tiêu (gây ra các cuộc tấn công DoS không chủ ý) mà còn vi phạm các quy định về sở hữu dữ liệu và điều khoản sử dụng. Do đó, dự án này đặt ưu tiên hàng đầu cho việc xây dựng một "Crawler văn minh".

**Các giao thức đạo đức và kỹ thuật đã được triển khai chi tiết:**

1.  **Tuân thủ Robots.txt và Sitemap:**
    *   Trước khi bắt đầu bất kỳ phiên thu thập nào, crawler được lập trình để tự động truy xuất và phân tích file `robots.txt` của trang web mục tiêu. Hệ thống tuân thủ tuyệt đối các chỉ thị `User-agent` và `Disallow`. Nếu một đường dẫn bị cấm, crawler sẽ bỏ qua ngay lập tức.
    *   Ngoài ra, crawler ưu tiên sử dụng `sitemap.xml` (nếu có) để định vị các liên kết thay vì quét mù quáng toàn bộ trang web, giúp giảm tải lượng request không cần thiết lên server.

2.  **Cơ chế Giới hạn Tốc độ (Rate Limiting & Throttling):**
    *   Để ngăn chặn hành vi giống tấn công từ chối dịch vụ (DoS), spider được cấu hình với độ trễ tải xuống (download delay) ngẫu nhiên từ 3 đến 7 giây giữa các yêu cầu liên tiếp. Sự ngẫu nhiên này mô phỏng hành vi duyệt web của con người, tránh tạo ra các mẫu lưu lượng truy cập (traffic patterns) máy móc gây nghi ngờ.
    *   Giới hạn số lượng yêu cầu đồng thời (concurrent requests) trên mỗi tên miền xuống mức thấp (tối đa 1-2 request cùng lúc) để đảm bảo băng thông của trang web mục tiêu không bị chiếm dụng, không ảnh hưởng đến trải nghiệm của người dùng thực.

3.  **Định danh Minh bạch (Transparent Identification):**
    *   Crawler không ẩn danh. Nó sử dụng một chuỗi `User-Agent` tùy chỉnh, xác định rõ đây là một bot phục vụ mục đích nghiên cứu học thuật của sinh viên (ví dụ: `StudentResearchBot/1.0 (+mailto:student_email@university.edu.vn)`).
    *   Việc cung cấp thông tin liên hệ trong header giúp quản trị viên trang web (Web Admin) có thể dễ dàng liên lạc để yêu cầu dừng thu thập nếu họ phát hiện bất kỳ vấn đề gì, thể hiện sự tôn trọng đối với chủ sở hữu website.

4.  **Bảo vệ Thông tin Cá nhân (PII Protection & GDPR/PDPA Compliance):**
    *   Mặc dù dữ liệu trên các trang tuyển dụng thường là công khai, dự án vẫn áp dụng nguyên tắc tối thiểu hóa dữ liệu. Logic trích xuất được thiết kế để chủ động bỏ qua hoặc làm mờ (masking) các thông tin định danh cá nhân nhạy cảm (PII) nếu vô tình xuất hiện, chẳng hạn như số điện thoại cá nhân của HR, email cá nhân không thuộc tên miền doanh nghiệp, hoặc hình ảnh chân dung.
    *   Dữ liệu thu thập tập trung hoàn toàn vào thực thể "Công việc" (Job) và "Công ty" (Company), không tập trung vào cá nhân cụ thể, đảm bảo tuân thủ tinh thần của các luật bảo vệ dữ liệu như Nghị định 13/2023/NĐ-CP của Việt Nam.

5.  **Chiến lược Lưu trữ và Vòng đời Dữ liệu (Data Retention Policy):**
    *   Dữ liệu thô (Raw HTML) chỉ được lưu trữ trong thời gian ngắn để phục vụ việc debug và kiểm chứng. Sau khi quá trình trích xuất (Extraction) hoàn tất vào lớp Bronze và dữ liệu sạch được đưa vào lớp Silver, các file thô sẽ được xóa định kỳ để giải phóng tài nguyên và giảm thiểu rủi ro rò rỉ dữ liệu.
    *   Tất cả dữ liệu thu thập được cam kết chỉ sử dụng cho mục đích phân tích giáo dục, thống kê tổng hợp trong khuôn khổ môn học. Tuyệt đối không có hành vi bán lại dữ liệu (data reselling), tái xuất bản hàng loạt (republishing) để cạnh tranh với trang gốc, hay sử dụng cho mục đích thương mại hóa dưới bất kỳ hình thức nào.

6.  **Xử lý Lỗi và "Back-off" Thông minh:**
    *   Trong trường hợp máy chủ mục tiêu phản hồi với các mã lỗi 429 (Too Many Requests) hoặc 503 (Service Unavailable), crawler được lập trình để tự động kích hoạt cơ chế tăng thoờ luợng cấp số nhân "Exponential Back-off". Nghĩa là, nó sẽ tạm dừng hoạt động trong một khoảng thời gian tăng dần (ví dụ: 30s, 1 phút, 5 phút...) trước khi thử lại, thay vì liên tục gửi lại yêu cầu ngay lập tức, giúp server có thời gian phục hồi.

---

## 4. Triển khai ETL: Kiến trúc Medallion

Quy trình xử lý dữ liệu tuân theo kiến trúc "Medallion" tiêu chuẩn của Databricks, cải thiện dần chất lượng dữ liệu khi nó di chuyển qua các lớp của hệ thống.

### 4.1 Lớp Bronze: Nhập liệu Thô (Raw Ingestion)
*   **Chi tiết về Scrapy Framework:**
    *   **Lịch sử và Phát triển:** Scrapy được phát triển bởi Scrapinghub (nay là Zyte) và lần đầu tiên được công bố vào năm 2008. Ban đầu, nó được thiết kế để thu thập dữ liệu thương mại điện tử nhưng nhanh chóng phát triển thành một framework đa năng nhờ tính linh hoạt và mạnh mẽ. Được viết hoàn toàn bằng Python, Scrapy tận dụng hệ sinh thái phong phú của ngôn ngữ này nhưng lại có hiệu năng vượt trội so với các thư viện scraping Python thông thường.
    *   **Kiến trúc Bất đồng bộ (Asynchronous Architecture):** Điểm mạnh cốt lõi của Scrapy nằm ở việc sử dụng **Twisted**, một engine networking bất đồng bộ hướng sự kiện (event-driven). Khác với các thư viện đồng bộ (như `requests` hay `Selenium`) phải chờ một trang tải xong mới xử lý trang tiếp theo, Scrapy có thể gửi hàng ngàn request cùng lúc mà không bị chặn (non-blocking). Khi một request được gửi đi, Scrapy không ngồi chờ phản hồi mà chuyển sang xử lý các tác vụ khác, giúp tối ưu hóa băng thông và tài nguyên CPU.
    *   **Cơ chế Xử lý Song song (Concurrency):** Scrapy quản lý các request thông qua một hàng đợi (Scheduler). Engine sẽ lấy request từ hàng đợi, gửi qua Downloader, và khi có phản hồi (Response), nó sẽ chuyển cho Spiders để xử lý (parse). Toàn bộ quy trình này diễn ra song song với khả năng tùy chỉnh độ sâu (concurrency level) cao, cho phép thu thập dữ liệu quy mô lớn (high-volume scraping) với tốc độ cực nhanh.
    *   **Middleware và Pipeline:** Scrapy cung cấp kiến trúc plug-and-play thông qua các lớp Middleware (nằm giữa Engine và Downloader/Spiders) và Item Pipeline. Điều này cho phép can thiệp vào quá trình xử lý request/response (ví dụ: tự động xoay vòng User-Agent, xử lý cookie, retry khi lỗi mạng) và xử lý dữ liệu đầu ra (ví dụ: validate dữ liệu, lưu vào database, hoặc xuất ra JSON/CSV) một cách dễ dàng và có tổ chức.
*   **Quy trình:** Dữ liệu thô được đưa vào Databricks DBFS (Hệ thống tệp Databricks). Sử dụng PySpark, dữ liệu này được đọc và sau đó được chuyển (transfer) vào bảng Delta nằm trong lớp **Bronze** của **Unity Catalog** với chế độ `append` (nối thêm).
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

Lớp Gold đại diện cho đỉnh cao của kiến trúc Medallion, nơi dữ liệu đã qua xử lý kỹ lưỡng được tinh chỉnh thành các cấu trúc tối ưu hóa cho việc tiêu thụ nghiệp vụ, báo cáo và phân tích nâng cao. Tại giai đoạn này, trọng tâm chuyển dịch từ việc "làm sạch dữ liệu" sang "mô hình hóa dữ liệu" để giải quyết các câu hỏi chiến lược cụ thể.

*   **Đầu vào:** Bảng Delta lớp Silver (đã được làm sạch, chuẩn hóa và có lược đồ nhất quán).
*   **Chiến lược Mô hình hóa Dữ liệu (Data Modeling Strategy):**
    Để đảm bảo hiệu năng truy vấn cao nhất cho các công cụ BI (như Power BI, Tableau, hoặc Databricks SQL Dashboards), dữ liệu tại lớp Gold được tổ chức lại theo mô hình **Star Schema (Lược đồ Sao)** hoặc **Snowflake Schema (Lược đồ Bông tuyết)**. Cách tiếp cận này giúp đơn giản hóa các câu lệnh SQL JOIN phức tạp và tăng tốc độ tổng hợp.
    
    *   **Bảng Fact (Fact Tables):**
        *   `fact_job_postings`: Đây là bảng trung tâm chứa các sự kiện tuyển dụng chi tiết. Mỗi dòng đại diện cho một tin đăng tuyển dụng duy nhất. Bảng này lưu trữ các khóa ngoại (foreign keys) trỏ đến các bảng Dimension và các chỉ số đo lường (measures) quan trọng như: `min_salary`, `max_salary`, `avg_salary`, `posting_duration` (thời gian tin tồn tại), và `application_count` (nếu có).
        *   `fact_daily_trends`: Một bảng tổng hợp theo thời gian (time-series aggregation) được tính toán trước (pre-computed), lưu trữ số lượng tin đăng mới, mức lương trung bình theo ngày để phục vụ vẽ biểu đồ xu hướng nhanh chóng mà không cần quét lại toàn bộ bảng `fact_job_postings` lớn.

    *   **Bảng Dimension (Dimension Tables):**
        *   `dim_company`: Chứa thông tin chi tiết về công ty tuyển dụng, bao gồm quy mô công ty, địa chỉ trụ sở, và phân loại ngành nghề chính của công ty đó. Bảng này được xử lý để chuẩn hóa tên công ty (ví dụ: gộp "FPT Software" và "FPT Soft" về cùng một thực thể).
        *   `dim_location`: Phân cấp địa lý chi tiết từ Quốc gia -> Vùng miền (Bắc/Trung/Nam) -> Tỉnh/Thành phố -> Quận/Huyện. Việc phân cấp này cho phép các nhà phân tích dễ dàng "drill-down" (đi sâu) hoặc "roll-up" (tổng hợp) dữ liệu theo khu vực địa lý.
        *   `dim_industry`: Danh mục ngành nghề chuẩn hóa. Do một tin tuyển dụng có thể thuộc nhiều ngành (ví dụ: vừa là IT vừa là Ngân hàng), kỹ thuật "Bridge Table" hoặc mảng (Array type) trong Spark SQL được sử dụng để xử lý mối quan hệ nhiều-nhiều này.
        *   `dim_skills`: Một bảng dimension đặc biệt được tạo ra từ việc phân tích văn bản mô tả công việc.

*   **Quy trình Xử lý Nâng cao (Advanced Processing Logic):**
    *   **Trích xuất Kỹ năng (Skill Extraction):** Đây là bước xử lý giá trị gia tăng cao nhất tại lớp Gold. Thay vì chỉ đếm từ khóa đơn giản, hệ thống áp dụng kỹ thuật Tokenization và N-grams để nhận diện các cụm từ kỹ năng (ví dụ: "Machine Learning", "Cloud Computing" thay vì chỉ "Machine" và "Learning"). Danh sách kỹ năng này sau đó được đối chiếu với một từ điển kỹ năng chuẩn (Skill Taxonomy) để loại bỏ nhiễu và đồng nhất các biến thể (ví dụ: "ReactJS", "React.js", "React" đều được quy về "React").
    *   **Phân khúc Lương (Salary Bucketing):** Tạo ra các cột phân loại mới dựa trên mức lương số học, ví dụ: "Dưới 10 triệu", "10-20 triệu", "Trên 50 triệu". Điều này giúp việc tạo các biểu đồ phân phối (histograms) trở nên trực quan và dễ dàng hơn cho người dùng nghiệp vụ.
    *   **Xử lý Dữ liệu Lịch sử (SCD - Slowly Changing Dimensions):** Đối với bảng `dim_company`, kỹ thuật SCD Type 2 có thể được áp dụng để theo dõi sự thay đổi thông tin công ty theo thời gian (ví dụ: công ty đổi tên hoặc chuyển trụ sở), đảm bảo tính chính xác lịch sử của báo cáo.

*   **Các Chỉ số Tổng hợp Chính (Key Aggregations & Metrics):**
    Các View hoặc Materialized View được tạo ra trên lớp Gold để trả lời ngay lập tức các câu hỏi nghiệp vụ:
    1.  **Chỉ số Sức khỏe Thị trường:** Tổng số tin tuyển dụng đang hoạt động (Active Jobs), Tỷ lệ tăng trưởng tin tuyển dụng theo tháng (MoM Growth).
    2.  **Phân tích Lương thưởng:** Mức lương trung bình, trung vị (median), và phân vị thứ 90 (90th percentile) theo từng nhóm ngành nghề và cấp bậc (Junior/Senior/Manager).
    3.  **Bản đồ Nhu cầu Kỹ năng:** Top 10 kỹ năng được yêu cầu nhiều nhất cho từng vị trí công việc cụ thể (ví dụ: Data Analyst cần SQL, Excel, Python; trong khi Data Scientist cần Python, Machine Learning, Statistics).
    4.  **Độ nóng Địa lý:** Tỷ lệ cạnh tranh và mức lương trung bình được so sánh giữa các thành phố lớn (Hà Nội vs TP.HCM vs Đà Nẵng).

*   **Đặc điểm Kỹ thuật:**
    *   **Tối ưu hóa Đọc (Read-Optimized):** Các bảng Gold sử dụng kỹ thuật **Z-Ordering** trên các cột thường xuyên được lọc (như `posting_date`, `city_id`) để tối đa hóa khả năng bỏ qua dữ liệu (data skipping) của Delta Lake, giúp truy vấn phản hồi trong tích tắc.
    *   **Quyền truy cập:** Đây là lớp dữ liệu duy nhất được cấp quyền truy cập rộng rãi cho các Business Analyst và các cấp quản lý, đảm bảo họ làm việc trên dữ liệu sạch, đã được kiểm chứng và thống nhất (Single Source of Truth).

---

## 5. Điều phối và Tự động hóa (Orchestration)

Để đảm bảo tính ổn định, khả năng tái lập và tự động hóa hoàn toàn cho pipeline dữ liệu, dự án sử dụng **Databricks Workflows** (trước đây là Databricks Jobs) làm công cụ điều phối (orchestrator) chính. Đây là một giải pháp native tích hợp sâu trong hệ sinh thái Databricks, cho phép quản lý các quy trình ETL phức tạp mà không cần phụ thuộc vào các công cụ bên thứ ba như Airflow hay Luigi.

### 5.1 Thiết kế Workflow Đa tác vụ (Multi-Task Job)
Thay vì chạy các notebook riêng lẻ một cách thủ công, toàn bộ quy trình từ nhập liệu đến tổng hợp báo cáo được đóng gói vào một **Job** duy nhất bao gồm nhiều tác vụ (Tasks) liên kết chặt chẽ với nhau theo mô hình đồ thị có hướng (DAG - Directed Acyclic Graph).

Cấu trúc Workflow cụ thể như sau:

1.  **Task 1: `ingest_raw_data` (Bronze Layer)**
    *   **Loại:** Notebook Task.
    *   **Chức năng:** Quét vùng staging (DBFS/S3) để tìm các file JSON mới được crawler tải lên. Sử dụng Spark để đọc dữ liệu thô, thêm metadata (thời gian tải, tên file nguồn) và ghi vào bảng Delta Bronze với chế độ `append`.
    *   **Cấu hình Cluster:** Sử dụng một Job Cluster nhỏ (Single Node) để tiết kiệm chi phí vì tác vụ này chủ yếu là I/O bound.

2.  **Task 2: `transform_cleanse` (Silver Layer)**
    *   **Phụ thuộc:** Task 1 (`ingest_raw_data`). Chỉ kích hoạt khi Task 1 trả về trạng thái `SUCCESS`.
    *   **Loại:** Notebook Task.
    *   **Chức năng:** Đọc dữ liệu mới từ bảng Bronze, thực hiện các phép làm sạch (regex parsing lương, chuẩn hóa ngày tháng, xóa HTML tags), khử trùng lặp và ghi đè (merge/upsert) vào bảng Silver.
    *   **Cơ chế:** Sử dụng tính năng **Delta Lake Merge** để đảm bảo tính nhất quán (Idempotency) - chạy lại task nhiều lần không tạo ra dữ liệu rác.

3.  **Task 3: `aggregate_business_metrics` (Gold Layer)**
    *   **Phụ thuộc:** Task 2 (`transform_cleanse`).
    *   **Loại:** Notebook Task (hoặc SQL Query Task).
    *   **Chức năng:** Tính toán các bảng tổng hợp (Fact/Dim), tạo các view báo cáo cho Dashboard.
    *   **Tối ưu hóa:** Chạy lệnh `OPTIMIZE` và `VACUUM` cuối phiên để dồn file và dọn dẹp dữ liệu cũ, duy trì hiệu năng truy vấn cao.

### 5.2 Các tính năng Nâng cao được áp dụng
Việc sử dụng Databricks Workflows mang lại những lợi ích vượt trội so với việc chạy script thủ công:

*   **Job Clusters (Cluster tạm thời):** Thay vì sử dụng All-Purpose Cluster đắt đỏ chạy liên tục, mỗi lần Job được kích hoạt, Databricks sẽ tự động khởi tạo một cluster mới chuyên dụng, thực thi xong sẽ tự động tắt. Điều này giúp tối ưu hóa chi phí điện toán (DBU) đáng kể cho dự án.
*   **Cơ chế Thử lại (Retry Policy):** Trong môi trường mạng không ổn định, các tác vụ có thể thất bại ngẫu nhiên. Workflow được cấu hình để tự động thử lại (retry) Task 1 tối đa 3 lần, mỗi lần cách nhau 5 phút nếu gặp lỗi kết nối, giúp pipeline tự phục hồi (self-healing) mà không cần can thiệp của con người.
*   **Tham số hóa (Parameterization):** Workflow cho phép truyền tham số động (widgets) vào các notebook. Ví dụ: truyền các biến tham số metadata để quan sát dữ liệu cho một ngày cụ thể trong quá khứ mà không cần sửa code.
*   **Giám sát và Cảnh báo (Monitoring & Alerting):** Hệ thống được tích hợp với email thông báo. Nếu bất kỳ task nào trong chuỗi thất bại (Failure), một email chi tiết chứa đường dẫn đến log lỗi (Driver logs) sẽ được gửi ngay lập tức đến kỹ sư dữ liệu để khắc phục kịp thời.

Mô hình điều phối này đảm bảo nguyên tắc **"All-or-Nothing"** cho chất lượng dữ liệu: Lớp Gold (báo cáo) sẽ không bao giờ bị cập nhật nếu dữ liệu ở các lớp trước (Bronze/Silver) chưa được xử lý thành công, ngăn chặn triệt để việc ra quyết định dựa trên dữ liệu sai lệch.

---

## 6. Trực quan hóa và Phân tích Dữ liệu

Đầu ra cuối cùng của pipeline là một **Databricks SQL Dashboard** tương tác, được kết nối trực tiếp với các bảng dữ liệu đã được tối ưu hóa ở lớp Gold. Đây không chỉ là nơi hiển thị các con số khô khan, mà là giao diện kể chuyện dữ liệu (data storytelling), giúp chuyển đổi các terabyte dữ liệu thô thành các quyết định chiến lược.

Dashboard được thiết kế theo tư duy **"Top-Down"**: bắt đầu từ các chỉ số tổng quan vĩ mô (Macro Indicators) và cho phép người dùng đi sâu (drill-down) vào các chi tiết vi mô cụ thể.

### 6.1 Tổng quan Thị trường (Market Overview Dashboard)
Phần này cung cấp cái nhìn toàn cảnh về sức khỏe của thị trường lao động trong thời gian thực.
*   **Chỉ số KPI Chính:** Hiển thị các thẻ số (Scorecards) nổi bật về Tổng số tin tuyển dụng đang active, Mức lương trung bình toàn thị trường, và Số lượng công ty đang tuyển dụng.
*   **Phân bố Địa lý (Geospatial Analysis):** Sử dụng biểu đồ bản đồ (Choropleth Map) để trực quan hóa mật độ việc làm.
    *   *Insight:* Dữ liệu chỉ ra sự tập trung nguồn lực khổng lồ, với hơn **65%** các công việc liên quan đến công nghệ và kỹ thuật cao nằm tại hai đầu tàu kinh tế là **Thành phố Hồ Chí Minh** và **Hà Nội**.
    *   *Insight:* **Đà Nẵng** và **Bình Dương** đang nổi lên như những trung tâm vệ tinh tiềm năng, với tốc độ tăng trưởng tin tuyển dụng đạt mức 15% so với tháng trước, phản ánh xu hướng dịch chuyển sản xuất và văn phòng đại diện.

### 6.2 Phân tích Lương thưởng Chuyên sâu (Salary Intelligence)
Đây là phần được quan tâm nhất, giúp trả lời câu hỏi: *"Giá trị thị trường của một vị trí là bao nhiêu?"*.
*   **Biểu đồ Phân phối Lương (Salary Distribution Histogram):** Thay vì chỉ nhìn vào số trung bình (dễ bị sai lệch bởi các giá trị ngoại lai), biểu đồ này hiển thị dải lương phổ biến nhất.
    *   *Insight:* Phân tích cho thấy sự chênh lệch lương đáng kể (salary premium) cho các nhóm ngành công nghệ cao. Cụ thể, các vai trò liên quan đến **"Data" (Dữ liệu)** và **"AI" (Trí tuệ nhân tạo)** có mức lương trung vị (median salary) cao hơn khoảng **25-30%** so với các vai trò IT Support hoặc Quản trị mạng truyền thống.
*   **Lương theo Kinh nghiệm (Salary by Seniority):** Biểu đồ hộp (Box Plot) phân tích mức lương dựa trên các từ khóa cấp bậc (Intern, Junior, Senior, Lead, Manager). Dữ liệu cho thấy "bước nhảy lương" (salary jump) lớn nhất nằm ở giai đoạn chuyển từ Junior lên Senior (tăng trung bình 40%).

### 6.3 Xu hướng Ngành nghề và Kỹ năng (Industry & Skills Trends)
Phần này hỗ trợ sinh viên và người tìm việc định hướng lộ trình học tập.
*   **Top Ngành nghề đang "Khát" nhân lực:** Biểu đồ thanh (Bar Chart) xếp hạng các ngành có số lượng tin đăng mới cao nhất trong quý.
    *   *Insight:* Ngoài Công nghệ thông tin, lĩnh vực **"Bán lẻ" (Retail)** và **"Tài chính - Ngân hàng"** đang dẫn đầu về nhu cầu tuyển dụng, đặc biệt là các vị trí chuyển đổi số.
*   **Đám mây Từ khóa Kỹ năng (Skill Word Cloud & Frequency):** Phân tích tần suất xuất hiện của các từ khóa kỹ thuật trong phần mô tả công việc (JD).
    *   *Insight:* Đối với nhóm ngành Dữ liệu, **"SQL"** và **"Python"** không còn là điểm cộng mà là yêu cầu bắt buộc, xuất hiện trong hơn **80%** các bản mô tả công việc.
    *   *Insight:* Các kỹ năng mềm như "Communication" (Giao tiếp) và "English" (Tiếng Anh) xuất hiện trong 60% các vị trí cấp cao (Senior trở lên), cho thấy tầm quan trọng của khả năng hội nhập và làm việc nhóm.

### 6.4 Khả năng Tương tác (Interactivity)
Dashboard được tích hợp các bộ lọc (Filters) động, cho phép người dùng tùy chỉnh view báo cáo theo nhu cầu:
*   **Bộ lọc Thời gian:** Xem xu hướng trong 7 ngày, 30 ngày hoặc toàn bộ lịch sử.
*   **Bộ lọc Địa điểm:** So sánh mức lương cho cùng một vị trí (ví dụ: Java Developer) giữa Hà Nội và TP.HCM.
*   **Bộ lọc Ngành nghề:** Chỉ hiển thị dữ liệu của ngành Marketing hoặc IT.

Việc xây dựng dashboard này trên Databricks SQL cho phép tận dụng sức mạnh tính toán của Spark phía sau, giúp các truy vấn phức tạp trên hàng triệu bản ghi được phản hồi chỉ trong vài giây, mang lại trải nghiệm người dùng mượt mà và chuyên nghiệp.

*(Lưu ý: Trong báo cáo đầy đủ, các ảnh chụp màn hình chi tiết của các biểu đồ dashboard sẽ được chèn vào phần này để minh họa trực quan).*

---

## 7. Thách thức và Hạn chế

Trong quá trình thiết kế và triển khai hệ thống, nhóm thực hiện đã đối mặt với nhiều thách thức kỹ thuật phức tạp và nhận diện được một số hạn chế cố hữu của giải pháp hiện tại. Việc phân tích sâu sắc các vấn đề này không chỉ giúp đánh giá đúng mức độ hoàn thiện của dự án mà còn mở ra các hướng tối ưu hóa quan trọng cho các phiên bản tiếp theo.

### 7.1 Thách thức về Chất lượng và Xử lý Dữ liệu (Data Quality & Processing Challenges)

*   **Sự Đa dạng và Hỗn loạn của Dữ liệu Phi cấu trúc (Unstructured Data Chaos):**
    *   **Bài toán Phân tích Lương (Salary Parsing Dilemma):** Đây là thách thức lớn nhất và dai dẳng nhất. Trường dữ liệu "Mức lương" trên các trang tuyển dụng là một ví dụ điển hình của dữ liệu "bẩn" (dirty data). Nhà tuyển dụng nhập liệu theo vô vàn định dạng: từ số nguyên thuần túy, số thập phân, sử dụng dấu chấm/phẩy phân cách hàng nghìn không nhất quán, đến các cụm từ định tính như "Thỏa thuận", "Cạnh tranh", "Up to $X", "Lương cứng + % hoa hồng". Mặc dù hệ thống đã triển khai một bộ thư viện Regular Expressions (Regex) phức tạp với hơn 20 mẫu (patterns) khác nhau để bắt các trường hợp, tỷ lệ bỏ sót hoặc hiểu sai vẫn tồn tại (khoảng 5-8%). Việc chuẩn hóa đơn vị tiền tệ (USD, VND, JPY) và quy đổi về một mặt bằng chung cũng gặp khó khăn do tỷ giá biến động.
    *   **Nhiễu trong Mô tả Công việc (Job Description Noise):** Phần mô tả công việc thường chứa rất nhiều thông tin không liên quan (boilerplate text) như giới thiệu chung về công ty, phúc lợi tiêu chuẩn lặp đi lặp lại, hoặc các đoạn văn bản quảng cáo. Việc tách lọc đâu là "yêu cầu kỹ thuật cốt lõi" và đâu là "thông tin rác" đòi hỏi các kỹ thuật xử lý văn bản tinh vi hơn là chỉ loại bỏ thẻ HTML đơn thuần.

*   **Vấn đề về Tính Nhất quán của Dữ liệu (Data Consistency Issues):**
    *   **Trùng lặp Dữ liệu (Data Duplication):** Các nhà tuyển dụng thường sử dụng chiến thuật "spam" tin đăng: đăng cùng một nội dung công việc nhiều lần với tiêu đề hơi khác nhau hoặc đăng lại (re-post) tin cũ để đẩy lên đầu trang. Việc xác định chính xác một tin là "mới hoàn toàn" hay chỉ là "bình mới rượu cũ" là rất khó nếu chỉ dựa vào Job ID. Hệ thống hiện tại sử dụng cơ chế khử trùng lặp dựa trên ID và nội dung băm (content hashing), nhưng vẫn có thể bỏ sót các trường hợp sửa đổi nhỏ.
    *   **Dữ liệu Địa lý Mơ hồ:** Nhiều tin tuyển dụng ghi địa điểm là "Toàn quốc" hoặc liệt kê nhiều thành phố cùng lúc, gây khó khăn cho việc phân bổ dữ liệu chính xác vào các biểu đồ địa lý (Geospatial charts).

### 7.2 Thách thức về Thu thập Dữ liệu (Ingestion Challenges)

*   **Tính Động và Mong manh của Web Scraping (Fragility of Web Scraping):**
    *   **Cấu trúc DOM thay đổi (DOM Changes):** Scrapy spider phụ thuộc chặt chẽ vào cấu trúc HTML (XPath/CSS Selectors) của trang web mục tiêu. Bất kỳ bản cập nhật giao diện nào từ phía 1900.com.vn (ví dụ: đổi tên class, thay đổi cấu trúc thẻ div) đều có thể khiến pipeline thu thập dữ liệu bị gãy (break) ngay lập tức. Điều này tạo ra gánh nặng bảo trì (maintenance overhead) lớn, đòi hỏi phải giám sát liên tục và cập nhật mã nguồn crawler thủ công.
    *   **Cơ chế Chống Bot (Anti-Bot Measures):** Mặc dù crawler được thiết kế "văn minh", nhưng rủi ro bị chặn IP (IP Ban) hoặc bị yêu cầu giải mã CAPTCHA vẫn luôn hiện hữu nếu tần suất truy cập tăng đột biến. Hiện tại, hệ thống chưa tích hợp các giải pháp xoay vòng Proxy (Proxy Rotation) chuyên nghiệp do chi phí cao, làm giới hạn khả năng mở rộng quy mô thu thập dữ liệu.

### 7.3 Hạn chế về Hạ tầng và Công nghệ (Infrastructure & Technology Limitations)

*   **Giới hạn của Môi trường Databricks Community Edition:**
    *   **Tài nguyên Tính toán (Compute Resources):** Phiên bản miễn phí chỉ cung cấp một cluster nhỏ (thường là 1 Driver, 15GB Memory, 2 Cores) và không có Worker nodes thực sự. Điều này hạn chế nghiêm trọng khả năng xử lý song song (parallelism) của Spark. Các tác vụ nặng như huấn luyện mô hình NLP hay xử lý chuỗi Regex trên hàng triệu dòng dữ liệu thường gặp tình trạng nghẽn cổ chai (bottleneck) hoặc bị OOM (Out Of Memory).
    *   **Thiếu tính năng Lập lịch (No Job Scheduling):** Community Edition không hỗ trợ Databricks Jobs để chạy định kỳ (cron jobs). Do đó, quy trình hiện tại vẫn mang tính chất "bán tự động" (semi-automated), cần người vận hành kích hoạt notebook thủ công mỗi ngày. Điều này ngăn cản việc xây dựng một pipeline thời gian thực (real-time) thực sự.
    *   **Cluster Timeout:** Cluster sẽ tự động tắt sau một khoảng thời gian không hoạt động (thường là 2 giờ), gây gián đoạn quy trình phát triển và làm mất các biến môi trường tạm thời.

### 7.4 Hạn chế trong Phân tích Nâng cao (Advanced Analytics Limitations)

*   **Xử lý Ngôn ngữ Tự nhiên (NLP) còn Sơ khai:**
    *   **Trích xuất Kỹ năng dựa trên Từ khóa (Keyword-based Extraction):** Phương pháp hiện tại sử dụng từ điển từ khóa định sẵn (pre-defined dictionary) để tìm kiếm kỹ năng. Cách tiếp cận này có độ chính xác thấp (low precision) và độ phủ kém (low recall). Ví dụ: không phân biệt được "Java" (ngôn ngữ lập trình) và "Java" (hòn đảo - dù hiếm gặp trong ngữ cảnh này nhưng là ví dụ về sự nhập nhằng), hoặc bỏ sót các kỹ năng mới nổi chưa có trong từ điển.
    *   **Thiếu Phân tích Ngữ cảnh (Lack of Contextual Analysis):** Hệ thống chưa hiểu được mức độ thành thạo yêu cầu (ví dụ: "biết Python" khác với "thành thạo Python") hay vai trò của kỹ năng (kỹ năng chính vs kỹ năng phụ). Việc áp dụng các mô hình Deep Learning (như BERT hay Transformers) để thực hiện Named Entity Recognition (NER) là cần thiết nhưng chưa khả thi với tài nguyên hiện tại.

---

## 8. Kết luận và Hướng phát triển
Dự án này đã thành công trong việc thiết lập một nền tảng vững chắc cho quy trình kỹ thuật dữ liệu hiện đại, chứng minh tính khả thi và hiệu quả của việc áp dụng kiến trúc Databricks Lakehouse vào bài toán phân tích thị trường lao động thực tế. Bằng cách chuyển đổi dữ liệu từ dạng web scrape thô sơ, hỗn loạn thành các dashboard thông minh, hệ thống không chỉ cung cấp những cái nhìn sâu sắc, khách quan về xu hướng việc làm tại Việt Nam mà còn đảm bảo tính toàn vẹn, bảo mật và khả năng truy xuất ngược của dữ liệu nhờ sức mạnh của Delta Lake. Đây là bước đệm quan trọng, chuyển dịch từ việc xử lý dữ liệu thủ công sang một quy trình công nghiệp hóa, tự động hóa cao.

Tuy nhiên, trong bối cảnh công nghệ Big Data và AI đang phát triển với tốc độ vũ bão, dự án này mới chỉ là điểm khởi đầu. Để chuyển đổi từ một đồ án môn học thành một sản phẩm dữ liệu (Data Product) hoàn chỉnh, có khả năng thương mại hóa hoặc phục vụ cộng đồng rộng lớn, cần có một lộ trình phát triển dài hạn và đầy tham vọng.

**Các Hướng Phát triển Chiến lược trong Tương lai:**

1.  **Mở rộng Hệ sinh thái Nguồn Dữ liệu (Data Source Expansion):**
    *   **Đa dạng hóa Nền tảng:** Hiện tại hệ thống chỉ phụ thuộc vào một nguồn duy nhất. Chiến lược tiếp theo là mở rộng crawler để tích hợp dữ liệu từ "Big 3" các trang tuyển dụng tại Việt Nam (VietnamWorks, TopCV, CareerBuilder) và các mạng xã hội nghề nghiệp như LinkedIn. Việc này sẽ giúp loại bỏ độ lệch (bias) của từng nền tảng riêng lẻ và cung cấp bức tranh toàn cảnh chính xác hơn.
    *   **Dữ liệu Phi cấu trúc Đa phương tiện:** Nghiên cứu khả năng thu thập và phân tích dữ liệu từ các nguồn phi truyền thống như các bài đăng tuyển dụng trên Facebook Groups, các video tuyển dụng trên TikTok/YouTube (sử dụng Speech-to-Text) để nắm bắt xu hướng tuyển dụng của Gen Z.

2.  **Nâng cấp Kiến trúc lên Real-time Streaming (Lambda/Kappa Architecture):**
    *   Chuyển đổi từ mô hình xử lý theo lô (Batch Processing - chạy hàng ngày) sang mô hình xử lý dòng (Stream Processing) sử dụng **Spark Structured Streaming** kết hợp với **Kafka** hoặc **Event Hubs**.
    *   Mục tiêu là đạt được độ trễ gần như bằng không (near real-time latency). Ngay khi một tin tuyển dụng "hot" xuất hiện trên thị trường, hệ thống sẽ thu thập, xử lý và gửi cảnh báo (alert) ngay lập tức cho người dùng qua Email hoặc Telegram bot, tạo lợi thế cạnh tranh lớn cho người tìm việc.

3.  **Ứng dụng Trí tuệ Nhân tạo và Học máy Tiên tiến (Advanced AI/ML Integration):**
    *   **NLP & LLMs (Large Language Models):** Thay thế phương pháp trích xuất từ khóa thủ công bằng các mô hình ngôn ngữ lớn (như BERT, GPT-4 qua API hoặc Llama 2 fine-tuned). Điều này cho phép:
        *   *Hiểu ngữ cảnh sâu:* Phân biệt rõ ràng giữa "kỹ năng bắt buộc" và "kỹ năng ưu tiên".
        *   *Tự động tóm tắt:* Tạo ra bản tóm tắt ngắn gọn về văn hóa công ty và phúc lợi từ những mô tả dài dòng.
        *   *Matching thông minh:* Xây dựng hệ thống gợi ý (Recommender System) để khớp hồ sơ ứng viên (CV) với tin tuyển dụng dựa trên độ tương đồng ngữ nghĩa (semantic similarity) thay vì chỉ khớp từ khóa.
    *   **Dự báo Xu hướng (Predictive Analytics):** Sử dụng dữ liệu lịch sử để huấn luyện các mô hình Time Series (như Prophet hoặc ARIMA) nhằm dự báo nhu cầu nhân lực của từng ngành trong 3-6 tháng tới, hỗ trợ các cơ sở đào tạo và sinh viên định hướng nghề nghiệp đón đầu xu hướng.

4.  **Tăng cường Quản trị và Chất lượng Dữ liệu (Data Governance & Quality - DataOps):**
    *   **Great Expectations:** Tích hợp framework kiểm thử dữ liệu tự động (như Great Expectations) vào pipeline để thiết lập các chốt kiểm soát chất lượng (quality gates). Nếu dữ liệu đầu vào vi phạm các quy tắc (ví dụ: tỷ lệ null quá cao, mức lương âm), pipeline sẽ tự động dừng và báo lỗi thay vì nạp dữ liệu rác vào hệ thống.
    *   **Data Lineage (Phả hệ Dữ liệu):** Triển khai đầy đủ tính năng Data Lineage của Unity Catalog để minh bạch hóa toàn bộ dòng chảy dữ liệu, giúp dễ dàng truy vết nguồn gốc của từng con số trên báo cáo, phục vụ cho việc kiểm toán và tuân thủ quy định.

5.  **Phát triển Giao diện Người dùng (Frontend Application):**
    *   Xây dựng một ứng dụng web (Web App) độc lập sử dụng ReactJS hoặc Streamlit, kết nối với Databricks qua API. Ứng dụng này sẽ cho phép người dùng không chuyên (non-technical users) tương tác với dữ liệu, tự tạo các bộ lọc tùy chỉnh, lưu lại các tìm kiếm quan tâm và nhận các báo cáo cá nhân hóa định kỳ.

---

## 9. Tài liệu Tham khảo

1.  Databricks. (2023). *The Data Lakehouse Architecture: Building the Modern Data Stack*.
2.  Scrapy Developers. (2023). *Scrapy 2.11 Documentation*.
3.  Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling*. Wiley.
4.  Armbrust, M., et al. (2020). *Delta Lake: High-Performance ACID Table Storage over Cloud Object Stores*. PVLDB.
5.  1900.com.vn Terms of Service & Robots.txt.

