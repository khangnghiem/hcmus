24C01045_NghiemMinhKhang
# 1: Document DB Design - BestEmp.com

## a) Document DB Design

### Users Collection
```json
[
    {
        "user_id": "...",
        "personal_info": {
            "name": "...",
            "email": "...",
            "phone": "...",
            "address": {
                "street": "...",
                "district": "...",
                "city": "...",
                "country": "..."
            },
            "avatar_url": "http://..."
        },
        "education": [
            {
                "institution": "...",
                "degree": "...",
                "field": "...",
                "duration": {
                    "start": "...",
                    "end": "..."
                },
                "grade": "..."
            }
        ],
        "experience": [
            {
                "company": "...",
                "location": "...",
                "position": "...",
                "start_date": "...",
                "end_date": "...",
                "description": "..."
            }
        ],
        "skills": [
            {
                "name": "...",
                "certified_by": "...",
                "certificate_url": "http://..."
            }
        ],
        "languages": [
            {
                "language": "...",
                "proficiency": "..."
            }
        ],
        "projects": [
            {
                "name": "...",
                "description": "...",
                "place": "...",
                "tech_stack": "...",
                "start_date": "...",
                "end_date": "..."
            }
        ],
        "connections": [
            {
                "user_id": "...",
                "since": "..."
            }
        ]
    }
]
```

### Posts Collection

```json
[
    {
        "id": "...",
        "user_id": "...",
        "content": "...",
        "posted_at": "...",
        "engagement": {
            "likes": "...",
            "comments": [
                {
                    "comment_id": "...",
                    "user_id": "...",
                    "comment_text": "...!",
                    "comment_date": "..."
                }
            ]
        }
    }
]
```

T1: User Profile (U001)
SELECT * FROM users WHERE users.user_id = 'U001'

T2: User Connections (U001)
SELECT users.connections FROM users WHERE users.user_id = 'U001'

T3: Post Comments (P002)
SELECT posts.engagement.comments FROM posts WHERE posts.id = 'P002'
let commenter_id = posts.engagement.comments.user_id
Then SELECT * FROM users WHERE users.user_id = commenter_id

## b) Giải thích lựa chọn

- Dữ liệu người dùng users và có cấu trúc lồng nhau (nested) → phù hợp lưu trong Document DB
- Truy vấn trực tiếp, không cần nhiều JOIN → tốc độ cao
- Dữ liệu comments có thể embed vào post để tối ưu T3

# 2: Relational DB
## a) DC1

Cả 2 documents đều không thoả mãn dạng chuẩn 1 vì có nhiều duplicates trong các field của khoá. Nested structures và nested list cũng tạo ra nhiều duplicates.

**Users Table**

| user_id | name | email | phone | street | district | city | country | avatar_url |
| ------- | ---- | ----- | ----- | ------ | -------- | ---- | ------- | ---------- |
| ...     | ...  | ...   | ...   | ...    | ...      | ...  | ...     | ...        |

**Posts Table**

| post_id | user_id | content | posted_at | likes |
| ------- | ------- | ------- | --------- | ----- |
| ...     | ...     | ...     | ...       | ...   |

## b) Normalisation

Users Table:

Primary Key: user_id
FDs: user_id → {name, email, phone, ...}
Normal Form: BCNF

Education Table:

Primary Key: edu_id
FDs: edu_id → {user_id, institution, ...}
Normal Form: BCNF
Overall Database Normal Form: BCNF

Experience Table:

Primary Key: experience_id  
FDs: experience_id → {user_id, company, location, position, start_date, end_date, description}  
Normal Form: BCNF

Skills Table:

Primary Key: skill_id  
FDs: skill_id → {user_id, name, certified_by, certificate_url}  
Normal Form: BCNF

Languages Table:

Primary Key: language_id  
FDs: language_id → {user_id, language, proficiency}  
Normal Form: BCNF

Projects Table:

Primary Key: project_id  
FDs: project_id → {user_id, name, description, place, tech_stack, start_date, end_date}  
Normal Form: BCNF

## c) DC3

### Users Table

| user_id | name | email | phone | street | district | city | country | avatar_url |
| ------- | ---- | ----- | ----- | ------ | -------- | ---- | ------- | ---------- |
| ...     | ...  | ...   | ...   | ...    | ...      | ...  | ...     | ...        |

### Education Table

| education_id | user_id | institution | degree | field | start | end | grade |
| ------------ | ------- | ----------- | ------ | ----- | ----- | --- | ----- |
| ...          | ...     | ...         | ...    | ...   | ...   | ... | ...   |

### Experience Table

| experience_id | user_id | company | location | position | start_date | end_date | description |
| ------------- | ------- | ------- | -------- | -------- | ---------- | -------- | ----------- |
| ...           | ...     | ...     | ...      | ...      | ...        | ...      | ...         |

### Skills Table

| skill_id | user_id | name | certified_by | certificate_url |
| -------- | ------- | ---- | ------------ | --------------- |
| ...      | ...     | ...  | ...          | ...             |

### Languages Table

| language_id | user_id | language | proficiency |
| ----------- | ------- | -------- | ----------- |
| ...         | ...     | ...      | ...         |

### Projects Table

| project_id | user_id | name | description | place | tech_stack | start_date | end_date |
| ---------- | ------- | ---- | ----------- | ----- | ---------- | ---------- | -------- |
| ...        | ...     | ...  | ...         | ...   | ...        | ...        | ...      |

### Connections Table

| connection_id | user_id | connected_user_id | since |
| ------------- | ------- | ----------------- | ----- |
| ...           | ...     | ...               | ...   |

### Posts Table

| post_id | user_id | content | posted_at | likes |
| ------- | ------- | ------- | --------- | ----- |
| ...     | ...     | ...     | ...       | ...   |

### Comments Table

| comment_id | post_id | user_id | comment_text | comment_date |
| ---------- | ------- | ------- | ------------ | ------------ |
| ...        | ...     | ...     | ...          | ...          |
