# Index
- [Index](#index)
- [1. Giới thiệu phạm vi tri thức](#1-giới-thiệu-phạm-vi-tri-thức)
- [2. Thu thập tri thức](#2-thu-thập-tri-thức)
- [3. Hệ Biểu diễn Tri thức cho Định luật Di truyền Mendel](#3-hệ-biểu-diễn-tri-thức-cho-định-luật-di-truyền-mendel)
  - [3.1. Mô hình tri thức](#31-mô-hình-tri-thức)
  - [3.2. Tập biến $ \\mathcal{V}$](#32-tập-biến--mathcalv)
  - [3.3. Tập sự kiện $ \\mathcal{F}$](#33-tập-sự-kiện--mathcalf)
  - [3.4. Tập luật $ \\mathcal{R}$](#34-tập-luật--mathcalr)
    - [3.4.1. Định luật đồng tính (Luật 1)](#341-định-luật-đồng-tính-luật-1)
    - [3.4.2. Định luật phân ly (Luật 2)](#342-định-luật-phân-ly-luật-2)
    - [3.4.3. Định luật phân ly độc lập (Luật 3)](#343-định-luật-phân-ly-độc-lập-luật-3)
    - [3.4.4. Bảng Punnett cho phép lai $ AaBb \\times AaBb$](#344-bảng-punnett-cho-phép-lai--aabb-times-aabb)
    - [3.4.5. Bảng Punnett cho phép lai $ AaBbCc \\times AaBbCc $](#345-bảng-punnett-cho-phép-lai--aabbcc-times-aabbcc-)
- [4. Thuật toán suy diễn](#4-thuật-toán-suy-diễn)
  - [4.1. Input](#41-input)
  - [4.2. Output](#42-output)
  - [4.3. Thuật toán](#43-thuật-toán)
- [5. Kết luận](#5-kết-luận)
- [6. References](#6-references)
- [7. Python Script](#7-python-script)

---

# 1. Giới thiệu phạm vi tri thức  
Tri thức tập trung vào **3 định luật Mendel**:  
- **Định luật đồng tính**: Thế hệ con lai F1 đồng tính khi bố mẹ thuần chủng khác biệt một tính trạng.  
- **Định luật phân ly**: Các cặp alen phân ly độc lập trong quá trình hình thành giao tử.  
- **Định luật phân ly độc lập**: Các cặp tính trạng di truyền độc lập với nhau.  

**Phạm vi tri thức:**  

- Chỉ áp dụng cho gen đơn, tính trạng trội-lặn hoàn toàn.  
- Không xét:
  - Trường hợp gen đa tính trạng allele, liên kết gen hoặc hoán vị gen.  
  - Trội không hoàn toàn
  - Tương tác gen
  - Liên kết gen & hoán vị gen
  - Di truyền giới tính chromosome X & Y
  - Đột biến gen/chromosome:
  - Môi trường ảnh hưởng biểu hiện gen

---

# 2. Thu thập tri thức  
**Nguồn tri thức:**  

- Các thí nghiệm trên cây đậu Hà Lan (1865)
- Sách giáo khoa Sinh học lớp 8

**Bảng tri thức:**  

| Định luật           | Mô tả                                                 | Ví dụ                           |
| ------------------- | ----------------------------------------------------- | ------------------------------- |
| **Đồng tính**       | F1 đồng tính nếu bố mẹ thuần chủng.                   | `P: AA × aa → F1: 100% Aa`      |
| **Phân ly**         | Tỉ lệ kiểu gen F2 là 1:2:1, kiểu hình 3:1.            | `F1: Aa × Aa → F2: 1AA:2Aa:1aa` |
| **Phân ly độc lập** | Các cặp gen phân ly độc lập, tỉ lệ kiểu hình (3:1)^n. | `AaBb × AaBb → 9:3:3:1`         |

---

# 3. Hệ Biểu diễn Tri thức cho Định luật Di truyền Mendel

## 3.1. Mô hình tri thức
Hệ thống được xây dựng dựa trên bộ ba $\mathcal{K} = (\mathcal{V}, \mathcal{F}, \mathcal{R})$:

## 3.2. Tập biến $ \mathcal{V}$

$ \mathcal{V} =$  {$G_p, G_m, G_o, T_p, T_m, T_o, R, C\$}

Trong đó:

- $ G_p, G_m$: Kiểu gen bố và mẹ (ví dụ: $Aa$, $Bb$)
- $ G_o$: Kiểu gen đời con
- $ T_p, T_m, T_o$: Kiểu hình tương ứng
- $ R$: Tỉ lệ phân ly
- $ C$: Bảng tổ hợp các tính trạng độc lập

## 3.3. Tập sự kiện $ \mathcal{F}$
$ \mathcal{F} = \{G_p = \alpha, G_m = \beta, T_p = \gamma, T_m = \delta\}$

Với $ \alpha, \beta \in $ { $AA, Aa, aa$ \} $ \times$ \{BB, Bb, bb\} $ \text{và}$ $ \gamma, \delta$ là kiểu hình tương ứng.

## 3.4. Tập luật $ \mathcal{R}$

### 3.4.1. Định luật đồng tính (Luật 1)
Nếu $ G_p = AA \land G_m = aa \Rightarrow G_o = Aa$ với độ tin cậy $c = 1.0 $

### 3.4.2. Định luật phân ly (Luật 2)
Nếu $ G_p = Aa \land G_m = Aa \Rightarrow R = \frac{1}{4}AA : \frac{1}{2}Aa : \frac{1}{4}aa $

$ F_1: \left(\frac{1}{2}A + \frac{1}{2}a\right)^2 = \frac{1}{4}AA + \frac{1}{2}Aa + \frac{1}{4}aa $

### 3.4.3. Định luật phân ly độc lập (Luật 3)
Với 2 cặp gen độc lập:
Nếu $ G_p = AaBb \land G_m = AaBb \Rightarrow F_1: \frac{9}{16}$A_B_ $ : \frac{3}{16}$ A_bb : $ \frac{3}{16}$ aaB_ $ : \frac{1}{16}aabb $

$ F_1: \left(\frac{1}{2}A + \frac{1}{2}a\right)^2 \otimes \left(\frac{1}{2}B + \frac{1}{2}b\right)^2 = \frac{9}{16}$A_B_ $ : \frac{3}{16}$ A_bb : $ \frac{3}{16}$ aaB_ $ : \frac{1}{16}aabb $

### 3.4.4. Bảng Punnett cho phép lai $ AaBb \times AaBb$

|        | **AB** | **Ab** | **aB** | **ab** |
| ------ | ------ | ------ | ------ | ------ |
| **AB** | AABB   | AABb   | AaBB   | AaBb   |
| **Ab** | AABb   | AAbb   | AaBb   | Aabb   |
| **aB** | AaBB   | AaBb   | aaBB   | aaBb   |
| **ab** | AaBb   | Aabb   | aaBb   | aabb   |

**Chú thích:**  
- Hàng và cột là các loại giao tử của bố mẹ (AB, Ab, aB, ab).
- Ô giao điểm là kiểu gen đời con tương ứng.
- Từ bảng này, đếm số lượng từng kiểu hình để ra tỉ lệ:  
    - `A_B_`: 9/16  
    - `A_bb`: 3/16  
    - `aaB_`: 3/16  
    - `aabb`: 1/16  

### 3.4.5. Bảng Punnett cho phép lai $ AaBbCc \times AaBbCc $

|         | **ABC** | **ABc** | **AbC** | **Abc** | **aBC** | **aBc** | **abC** | **abc** |
| ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| **ABC** | AABBCC  | AABBCc  | AABbCC  | AABbCc  | AaBBCC  | AaBBCc  | AaBbCC  | AaBbCc  |
| **ABc** | AABBCc  | AABBcc  | AABbCc  | AABbcc  | AaBBCc  | AaBBcc  | AaBbCc  | AaBbcc  |
| **AbC** | AABbCC  | AABbCc  | AAbbCC  | AAbbCc  | AaBbCC  | AaBbCc  | AabbCC  | AabbCc  |
| **Abc** | AABbCc  | AABbcc  | AAbbCc  | AAbbcc  | AaBbCc  | AaBbcc  | AabbCc  | Aabbcc  |
| **aBC** | AaBBCC  | AaBBCc  | AaBbCC  | AaBbCc  | aaBBCC  | aaBBCc  | aaBbCC  | aaBbCc  |
| **aBc** | AaBBCc  | AaBBcc  | AaBbCc  | AaBbcc  | aaBBCc  | aaBBcc  | aaBbCc  | aaBbcc  |
| **abC** | AaBbCC  | AaBbCc  | AabbCC  | AabbCc  | aaBbCC  | aaBbCc  | aabbCC  | aabbCc  |
| **abc** | AaBbCc  | AaBbcc  | AabbCc  | Aabbcc  | aaBbCc  | aaBbcc  | aabbCc  | aabbcc  |

**Chú thích:**  
- Hàng và cột là các loại giao tử của bố mẹ (ABC, ABc, AbC, Abc, aBC, aBc, abC, abc).
- Ô giao điểm là kiểu gen đời con tương ứng.
- Tổng số tổ hợp: 64 (8x8).
- Đếm số lượng từng kiểu hình để ra tỉ lệ:  
    - `A_B_C_`: 27/64  
    - `A_B_C`: 9/64  
    - `A_B_c_`: 9/64  
    - ... (tương tự cho các kiểu hình khác)

# 4. Thuật toán suy diễn

Suy diễn tiến (Forward Chaining):

- Bước 1: Nhận input kiểu gen bố mẹ.
- Bước 2: Áp dụng luật Mendel tương ứng. Tách các tính trạng độc lập nhau với nhau thành input độc lập
- Bước 3: Tính toán tỉ lệ kiểu gen/kiểu hình. (genotype/phenotype)
- Bước 4: Trả kết quả kèm theo tỉ lệ

## 4.1. Input
- Kiểu gen bố mẹ: $ G_p, G_m \in \mathcal{V}$
- Bảng tính trạng: $ A \succ a$ (trội hoàn toàn)

## 4.2. Output
- Phân phối kiểu gen ở đời con $ P(G_o)$
- Phân phối kiểu hình ở đời con $ P(T_o)$

## 4.3. Thuật toán

1. **Bước khởi tạo**:

$ \mathcal{F}_0 = \{G_p = \alpha, G_m = \beta\} $

2. **Áp dụng luật**:

   $ \forall r_i \in R,\ \text{if premise}(r_i) \subseteq F_t \Rightarrow F_{t+1} = F_t \cup \text{conclusion}(r_i)$

3. **Tính tỉ lệ**:

   $ P(G_o) = \prod_{i=1}^n P(\text{giao tử})_i$

---

# 5. Kết luận
Thuật toán đã triển khai thành công các định luật di truyền Mendel để tính toán phân bố kiểu gen (genotype) và kiểu hình (phenotype) của thế hệ F1. Cụ thể:

- Tính đúng đắn:
  - Áp dụng luật phân ly độc lập (Law of Independent Assortment) và luật phân ly (Law of Segregation) để xác định tỉ lệ các tổ hợp gen.
  - Cho kết quả chính xác với phân số (Fraction), tránh sai số khi dùng số thực (float).
- Linh hoạt:
  - Xử lý được đa gen (monohybrid, dihybrid, trihybrid,...).
  - Dễ dàng mở rộng cho các trường hợp gen liên kết, gen đa alen, hoặc tính trạng trội không hoàn toàn.
- Ứng dụng:
  - Hỗ trợ nghiên cứu di truyền học, lai tạo giống cây trồng/vật nuôi.
  - Làm nền tảng cho hệ thống dự đoán di truyền (Genetics Prediction System) hoặc phần mềm giáo dục Sinh học.

Kết luận: Thuật toán đã hiện thực hóa chính xác lý thuyết Mendel, có tiềm năng ứng dụng cao trong nghiên cứu và giảng dạy Di truyền học.
Hướng phát triển: Mở rộng cho tính trạng liên kết giới tính.

---

# 6. References

1. Bộ Giáo dục và Đào tạo. (2020). *Sách giáo khoa Sinh học 8*. Nhà xuất bản Giáo dục Việt Nam.

---

# 7. Python Script

```python
import polars as pl
import itertools
from fractions import Fraction


def calculate_genotypes(parent1, parent2):
    gene_pairs1 = [parent1[i : i + 2] for i in range(0, len(parent1), 2)]
    gene_pairs2 = [parent2[i : i + 2] for i in range(0, len(parent2), 2)]
    gametes1 = [list(pair) for pair in gene_pairs1]
    gametes2 = [list(pair) for pair in gene_pairs2]
    parent1_gametes = list(itertools.product(*gametes1))
    parent2_gametes = list(itertools.product(*gametes2))
    genotype_counts = {}
    total = 0
    for g1 in parent1_gametes:
        for g2 in parent2_gametes:
            genotype = "".join("".join(sorted([a1, a2])) for a1, a2 in zip(g1, g2))
            genotype_counts[genotype] = genotype_counts.get(genotype, 0) + 1
            total += 1
    return {k: Fraction(v, total) for k, v in genotype_counts.items()}


def calculate_phenotypes(genotype_dist, dominance_map):
    phenotype_counts = {}
    for genotype, prob in genotype_dist.items():
        phenotype = []
        for i in range(0, len(genotype), 2):
            gene_pair = genotype[i : i + 2]
            if gene_pair[0].isupper():
                phenotype.append(dominance_map[gene_pair[0].upper()])
            else:
                phenotype.append(dominance_map[gene_pair[0]])
        phenotype_key = " ".join(phenotype)
        phenotype_counts[phenotype_key] = (
            phenotype_counts.get(phenotype_key, Fraction(0)) + prob
        )
    return phenotype_counts


dominance_map = {
    "A": "Hoa Đỏ",
    "a": "Hoa Trắng",
    "B": "Nụ Xanh",
    "b": "Nụ Trắng",
    "C": "Quả Vàng",
    "c": "Quả Trắng",
}


# Example 0: Aa x Aa
parent1_ex0 = "Aa"
parent2_ex0 = "Aa"
genotype_dist_ex0 = calculate_genotypes(parent1_ex0, parent2_ex0)
phenotype_dist_ex0 = calculate_phenotypes(genotype_dist_ex0, dominance_map)

# Example 1: AaBb x AaBb
parent1_ex1 = "AaBb"
parent2_ex1 = "AaBb"
genotype_dist_ex1 = calculate_genotypes(parent1_ex1, parent2_ex1)
phenotype_dist_ex1 = calculate_phenotypes(genotype_dist_ex1, dominance_map)

# Example 2: AABB x aabb
parent1_ex2 = "AABB"
parent2_ex2 = "aabb"
genotype_dist_ex2 = calculate_genotypes(parent1_ex2, parent2_ex2)
phenotype_dist_ex2 = calculate_phenotypes(genotype_dist_ex2, dominance_map)

# Example 3: AaBB x aaBb
parent1_ex3 = "AaBB"
parent2_ex3 = "aaBb"
genotype_dist_ex3 = calculate_genotypes(parent1_ex3, parent2_ex3)
phenotype_dist_ex3 = calculate_phenotypes(genotype_dist_ex3, dominance_map)

# Example 4: AaBb x Aabb
parent1_ex4 = "AaBb"
parent2_ex4 = "Aabb"
genotype_dist_ex4 = calculate_genotypes(parent1_ex4, parent2_ex4)
phenotype_dist_ex4 = calculate_phenotypes(genotype_dist_ex4, dominance_map)

# Example 5: AaBbCc x AaBbCc
parent1_ex5 = "AaBbCc"
parent2_ex5 = "AaBbCc"
genotype_dist_ex5 = calculate_genotypes(parent1_ex5, parent2_ex5)
phenotype_dist_ex5 = calculate_phenotypes(genotype_dist_ex5, dominance_map)


def dist_to_df(genotype_dist, phenotype_dist):
    geno_df = pl.DataFrame(
        {
            "Genotype": list(genotype_dist.keys()),
            "Probability": [str(p) for p in genotype_dist.values()],
        }
    )
    pheno_df = pl.DataFrame(
        {
            "Phenotype": list(phenotype_dist.keys()),
            "Probability": [str(p) for p in phenotype_dist.values()],
        }
    )
    return geno_df, pheno_df


def show_demo_table(parent1, parent2, genotype_dist, phenotype_dist):
    print(f"\nParents: {parent1} x {parent2}")
    geno_df, pheno_df = dist_to_df(genotype_dist, phenotype_dist)
    print("\nGenotype Distribution:")
    display(geno_df)
    print("\nPhenotype Distribution:")
    display(pheno_df)


# Demo tables for all examples
show_demo_table(parent1_ex5, parent2_ex5, genotype_dist_ex5, phenotype_dist_ex5)
show_demo_table(parent1_ex0, parent2_ex0, genotype_dist_ex0, phenotype_dist_ex0)
show_demo_table(parent1_ex1, parent2_ex1, genotype_dist_ex1, phenotype_dist_ex1)
show_demo_table(parent1_ex2, parent2_ex2, genotype_dist_ex2, phenotype_dist_ex2)
show_demo_table(parent1_ex3, parent2_ex3, genotype_dist_ex3, phenotype_dist_ex3)
show_demo_table(parent1_ex4, parent2_ex4, genotype_dist_ex4, phenotype_dist_ex4)
```
