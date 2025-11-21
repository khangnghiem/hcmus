from neo4j import GraphDatabase


class TaxonomyGraph:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))

    def close(self):
        self.driver.close()

    def create_taxonomy(self, taxonomy_dict):
        query = """
        MERGE (k:Kingdom {name: $kingdom})
        MERGE (p:Phylum {name: $phylum}) MERGE (k)-[:HAS_PHYLUM]->(p)
        MERGE (c:Class {name: $class_}) MERGE (p)-[:HAS_CLASS]->(c)
        MERGE (o:Order {name: $order}) MERGE (c)-[:HAS_ORDER]->(o)
        MERGE (f:Family {name: $family}) MERGE (o)-[:HAS_FAMILY]->(f)
        MERGE (g:Genus {name: $genus}) MERGE (f)-[:HAS_GENUS]->(g)
        MERGE (s:Species {name: $species}) MERGE (g)-[:HAS_SPECIES]->(s)
        """
        with self.driver.session() as session:
            session.run(
                query,
                {
                    "kingdom": taxonomy_dict["Kingdom"],
                    "phylum": taxonomy_dict["Phylum"],
                    "class_": taxonomy_dict["Class"],
                    "order": taxonomy_dict["Order"],
                    "family": taxonomy_dict["Family"],
                    "genus": taxonomy_dict["Genus"],
                    "species": taxonomy_dict["Species"],
                },
            )


# Example usage
if __name__ == "__main__":
    taxo = TaxonomyGraph("bolt://localhost:7687", "neo4j", "password")
    homo_sapiens = {
        "Kingdom": "Animalia",
        "Phylum": "Chordata",
        "Class": "Mammalia",
        "Order": "Primates",
        "Family": "Hominidae",
        "Genus": "Homo",
        "Species": "Homo sapiens",
    }
    taxo.create_taxonomy(homo_sapiens)
    taxo.close()


def get_classification(self, species_name):
    query = """
    MATCH path = (k:Kingdom)-[:HAS_PHYLUM|HAS_CLASS|HAS_ORDER|HAS_FAMILY|HAS_GENUS|HAS_SPECIES*]->(s:Species {name: $species})
    RETURN nodes(path) AS classification
    """
    with self.driver.session() as session:
        result = session.run(query, {"species": species_name})
        for record in result:
            for node in record["classification"]:
                print(f"{list(node.labels)[0]}: {node['name']}")
