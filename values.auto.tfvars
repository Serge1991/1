team_emails             = ["yovozhik@hotmail.com", "s.padvoiski@gmail.com", "cfcalpa@gmail.com", "sagynbekova022@gmail.com", "Mmassaee@gmail.com", "alex.chamedyuk@gmail.com", "gretskiyoleg88@gmail.com", "nataly5829@gmail.com", "Anton209306@gmail.com", "evgenyglinskiy@gmail.com", "giorgirex7@gmail.com", "imrankaramov@gmail.com", "olenagorbova1993@gmail.com"]
evaluation_periods      = 10
threshold               = 75
period                  = 60
comparison_operator     = "GreaterThanOrEqualToThreshold"
metric_name             = "CPUUtilization"
namespace               = "AWS/RDS"
namespace_ELB           = "AWS/ApplicationELB"
threshold_elb           = 1
evaluation_periods_elb  = 3
period_time             = 300
height                  = 4
width                   = 6
region                  = "us-east-1"
stat                    = "Average"
LoadBalancer            = "X"
RDS_instance_ID         = "X"
ASG_name                = "X"
RDS_instance_identifier = "X"
