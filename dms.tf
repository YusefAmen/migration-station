resource "aws_dms_replication_instance" "dms" {
  replication_instance_id = "dms-instance"
  replication_instance_class = "dms.t3.medium"
  allocated_storage = 100
  engine_version = "3.4.7"
}

resource "aws_dms_endpoint" "source" {
  endpoint_id = "source-db"
  endpoint_type = "source"
  engine_name = "postgres"
  username = "admin"
  password = "password123!"
  server_name = "postgres.default.svc.cluster.local"
  port = 5432
}

resource "aws_dms_endpoint" "target" {
  endpoint_id = "aurora-db"
  endpoint_type = "target"
  engine_name = "aurora-postgresql"
  username = "admin"
  password = "password123!"
  server_name = aws_rds_cluster.aurora.endpoint
  port = 5432
}

resource "aws_dms_replication_task" "migration_task" {
  replication_task_id   = "postgres-to-aurora"
  migration_type        = "full-load-and-cdc"
  source_endpoint_arn   = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn   = aws_dms_endpoint.target.endpoint_arn
  replication_instance_arn = aws_dms_replication_instance.dms.replication_instance_arn
}

