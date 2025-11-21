from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from neo4j import GraphDatabase
from typing import List

app = FastAPI()


class TaxonomyModel(BaseModel):
    Kingdom: str
    Phylum: str
    Class: str
    Order: str
    Family: str
    Genus: str
    Species: str


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

    def get_classification(self, species_name):
        query = """
        MATCH path = (k:Kingdom)-[:HAS_PHYLUM|HAS_CLASS|HAS_ORDER|HAS_FAMILY|HAS_GENUS|HAS_SPECIES*]->(s:Species {name: $species})
        RETURN nodes(path) AS classification
        """
        with self.driver.session() as session:
            result = session.run(query, {"species": species_name})
            for record in result:
                return [
                    {"label": list(node.labels)[0], "name": node["name"]}
                    for node in record["classification"]
                ]
        return []


taxo = TaxonomyGraph("bolt://localhost:8080", "neo4j", "password")


@app.post("/add_taxonomy")
def add_taxonomy(data: TaxonomyModel):
    taxo.create_taxonomy(data.model_dump())
    return {"status": "success"}


@app.get("/classification/{species_name}")
def classification(species_name: str):
    result = taxo.get_classification(species_name)
    if not result:
        raise HTTPException(status_code=404, detail="Species not found")
    return result


@app.get("/")
def index():
    return {"message": "TaxonomyGraph API running on localhost!"}
