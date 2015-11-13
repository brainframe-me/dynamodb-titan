# This is a python 3.4 test script using bulbsflow to connect to titan
#
# First install bulbsflow:
# - pip install bulbs
#
# TEST Commands:
# - http://bulbflow.com/quickstart/#create-the-graph-object

from bulbs.titan import Graph, Config
from bulbs.config import DEBUG, ERROR
from bulbs.model import Node, Relationship
from bulbs.property import String, Integer, DateTime
from bulbs.utils import current_datetime

config = Config("http://localhost:8182/graphs/yourdatabasename/")
g = Graph(config)

g.config.set_logger(DEBUG)
# g.config.set_logger(ERROR)

james = g.vertices.create(name="James")
julie = g.vertices.create(name="Julie")
g.edges.create(james, "knows", julie)

