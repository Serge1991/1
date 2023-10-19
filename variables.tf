variable "team_emails" {
  type = list(string)
}

variable "evaluation_periods" {
  type = number
}
variable "threshold" {
  type = number
}
variable "period" {
  type = number
}

variable "comparison_operator" {
  type = string
}

variable "metric_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "namespace_ELB" {
  type = string
}

variable "LoadBalancer" {
  type = string
}

variable "RDS_instance_ID" {
  type = string
}

variable "threshold_elb" {
  type = number
}

variable "evaluation_periods_elb" {
  type = number
}

variable "ASG_name" {
  type = string
}

variable "RDS_instance_identifier" {
  type = string
}

variable "period_time" {
  type = number
}

variable "region" {
  type = string
}
variable "stat" {
  type = string
}

variable "height" {
  type = number
}

variable "width" {
  type = number
}
