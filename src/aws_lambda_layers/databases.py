import os
from ssl import SSLContext
from ssl import CERT_REQUIRED
from ssl import PROTOCOL_TLSv1_2
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra.policies import DCAwareRoundRobinPolicy
import psycopg2


CASSANDRA_USERNAME = os.environ["CASSANDRA_USERNAME"]
CASSANDRA_PASSWORD = os.environ["CASSANDRA_PASSWORD"]
CASSANDRA_HOST = os.environ["CASSANDRA_HOST"].split(',')
CASSANDRA_PORT = os.environ["CASSANDRA_PORT"]
CASSANDRA_LOCAL_DC = os.environ["CASSANDRA_LOCAL_DC"]
CASSANDRA_KEYSPACE_NAME = os.environ["CASSANDRA_KEYSPACE_NAME"]
POSTGRESQL_USERNAME = os.environ["POSTGRESQL_USERNAME"]
POSTGRESQL_PASSWORD = os.environ["POSTGRESQL_PASSWORD"]
POSTGRESQL_HOST = os.environ["POSTGRESQL_HOST"]
POSTGRESQL_PORT = os.environ["POSTGRESQL_PORT"]
POSTGRESQL_DB_NAME = os.environ["POSTGRESQL_DB_NAME"]


def create_cassandra_connection():
    ssl_context = SSLContext(PROTOCOL_TLSv1_2)
    ssl_context.load_verify_locations('/opt/python/lib/python3.8/site-packages/AmazonRootCA1.pem')
    ssl_context.verify_mode = CERT_REQUIRED
    auth_provider = PlainTextAuthProvider(
        username=CASSANDRA_USERNAME,
        password=CASSANDRA_PASSWORD
    )
    cluster = Cluster(
        CASSANDRA_HOST,
        ssl_context=ssl_context,
        auth_provider=auth_provider,
        port=CASSANDRA_PORT,
        load_balancing_policy=DCAwareRoundRobinPolicy(local_dc=CASSANDRA_LOCAL_DC),
        protocol_version=4,
        connect_timeout=60,
        idle_heartbeat_interval=0
    )
    connection = cluster.connect()
    return connection


def create_postgresql_connection():
    connection = psycopg2.connect(
        user=POSTGRESQL_USERNAME,
        password=POSTGRESQL_PASSWORD,
        host=POSTGRESQL_HOST,
        port=POSTGRESQL_PORT,
        database=POSTGRESQL_DB_NAME
    )
    return connection
