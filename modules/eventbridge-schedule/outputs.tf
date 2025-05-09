# File: modules/eventbridge-schedule/outputs.tf

# Output the names of the created schedules
output "schedule_names" {
  description = "Names of the created EventBridge schedules."
  value       = [for name, schedule in aws_scheduler_schedule.this : schedule.name]
}