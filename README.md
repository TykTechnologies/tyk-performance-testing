# Tyk Performance Testing - WIP

This repository aims to replace the [tyk-ansible-performance-testing](https://github.com/TykTechnologies/tyk-ansible-performance-testing)

Why?
- Ansible scripts that stand up cloud resources are not idempotent which causes a lot of automation problems defeating the purpose of the project
- Installing different resources on bare-metal resources can be challenging which different resources changes across different clouds
- The market is interested in a k8s benchmarks rather than docker on bare-metal
- `hey` testing library is not the best tool for the job, moving to k6 by Grafana

How?
This repository will give you the ability to stand the different infrastructure using `Terraform` and `Helm`. With their 
idempotent nature, Terraform and Helm will make for a smoother and easier route to test Tyk and their competitors.

There are 4 ways to run these tests:
- AWS
- GCP
- Azure
- Self-Manged k8s cluster
