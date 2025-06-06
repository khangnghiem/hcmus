# 5. Python Script

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