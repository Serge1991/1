resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              var.namespace,
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.RDS_instance_identifier
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "RDS CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              var.namespace,
              "MemoryUsage",
              "DBInstanceIdentifier",
              var.RDS_instance_identifier
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "RDS Memory Utilization"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              var.namespace,
              "FreeStorageSpace",
              "DBInstanceIdentifier",
              var.RDS_instance_identifier
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "RDS Free Storage Space"
        }
      },
      {
        type   = "metric"
        x      = 18
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              var.namespace,
              "DatabaseConnections",
              "DBInstanceIdentifier",
              var.RDS_instance_identifier
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "RDS Database Connections"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = var.width
        height = var.height
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            [
              var.namespace_ELB,
              "ActiveConnectionCount",
              "LoadBalancer",
              var.LoadBalancer
            ]
          ]
          title  = "ALB Active Connections"
          region = var.region
        }
      },
      {
        type   = "metric",
        x      = 6
        y      = 0
        width  = var.width
        height = var.height
        properties = {
          view    = "timeSeries",
          stacked = false,
          metrics = [
            [
              var.namespace_ELB,
              "HTTPCode_ELB_4XX",
              "LoadBalancer",
              var.LoadBalancer
            ]
          ],
          title  = "ALB 4xx Error Rate",
          region = var.region
        }
      },
      {
        type   = "metric",
        x      = 12
        y      = 0
        width  = var.width
        height = var.height
        properties = {
          view    = "timeSeries",
          stacked = false,
          metrics = [
            [
              var.namespace_ELB,
              "RequestCount",
              "LoadBalancer",
              var.LoadBalancer
            ]
          ],
          title  = "ALB Request Count",
          region = var.region
        }
      },
      {
        type   = "metric"
        x      = 18
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              var.namespace_ELB,
              "UnHealthyHostCount",
              "LoadBalancer",
              var.LoadBalancer
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "ALB Unhealthy Host Count"
        }
      },
      {
        type   = "metric",
        x      = 0
        y      = 0
        width  = var.width
        height = var.height
        properties = {
          view    = "timeSeries",
          stacked = false,
          metrics = [
            [
              "AWS/EC2",
              "StatusCheckFailed",
              "AutoScalingGroupName",
              var.ASG_name
            ]
          ],
          title  = "ASG Instance Health",
          region = var.region
        }
      },
      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.ASG_name
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "ASG CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "MemoryUtilization",
              "AutoScalingGroupName",
              var.ASG_name
            ]
          ]
          period = var.period_time
          stat   = var.stat
          region = var.region
          title  = "ASG Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 18
        y      = 0
        width  = var.width
        height = var.height

        properties = {
          metrics = [
            [
              "AWS/AutoScaling",
              "TotalInstanceCount",
              "AutoScalingGroupName",
              var.ASG_name
            ]
          ]
          period = var.period_time
          stat   = "SampleCount"
          region = var.region
          title  = "ASG Total Instances"
        }
      }
    ]
  })
}

###### Creating SNS topics

resource "aws_sns_topic" "rds_cpu_alarm_topic" {
  name = "RDS_CPU_Alarm"
}
resource "aws_sns_topic" "ELB_alarm_topic" {
  name = "ELB_Alarm"
}

##### Adding multiple email subscriptions to RDS_CPU_alarm SNS topic

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each  = { for idx, email in var.team_emails : idx => email }
  topic_arn = aws_sns_topic.rds_cpu_alarm_topic.arn
  protocol  = "email"
  endpoint  = each.value
}

##### Adding multiple email subscriptions to ELB_alarm SNS topic

resource "aws_sns_topic_subscription" "email_subscriptions_2" {
  for_each  = { for idx, email in var.team_emails : idx => email }
  topic_arn = aws_sns_topic.ELB_alarm_topic.arn
  protocol  = "email"
  endpoint  = each.value
}


##### Creating a CloudWatch Alarm for RDS_CPU_utilization

resource "aws_cloudwatch_metric_alarm" "RDS_cpu_alarm" {
  alarm_name          = "CPU_utilization_RDS_alarm"
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = "Average"
  threshold           = var.threshold
  alarm_description   = "Triggered when RDS CPU utilization exceeds 75% for 10 minutes consecutively"
  alarm_actions       = [aws_sns_topic.rds_cpu_alarm_topic.arn]
  dimensions = {
    DBInstanceIdentifier = var.RDS_instance_identifier
  }
}

##### Creating a CloudWatch Alarm for ELB HTTP errors

resource "aws_cloudwatch_metric_alarm" "elb_http_alarm" {
  alarm_name          = "ELB_Error_Alarm"
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods_elb
  metric_name         = "HTTP_errors_ELB"
  namespace           = var.namespace_ELB
  period              = var.period
  statistic           = "Sum"
  threshold           = var.threshold_elb
  alarm_description   = "Triggered when ELB errors exceed 1 per minute"
  alarm_actions       = [aws_sns_topic.ELB_alarm_topic.arn]
  dimensions = {
    LoadBalancer = var.LoadBalancer
  }
}
