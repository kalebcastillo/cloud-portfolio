# Kaleb Castillo Cloud Portfolio/Blog

> Cloud/DevOps portfolio/blog website built with Astro, deployed to Azure with Terraform.

## 🚀 Getting Started

### Using DevContainer

- Install the Dev containers extension in VS Code

```bash
# Command Palette → "Dev Containers: Reopen in Container"
```

### Local Development

```bash
pnpm dev
```

## 📁 Project Structure

```
cloud-portfolio/
├── site/               # Astro website
├── infra/              # Terraform IaC
│   ├── modules/        # Reusable modules
│   ├── envs/           # Environment configs
│   └── backend/        # State management
└── tests/              # Python tests
```

## 🛠️ Tech Stack

- **Frontend**: Astro, Svelte, Tailwind CSS (Template by [Saica](https://github.com/saicaca))
- **Infrastructure**: Terraform, Azure
- **CI/CD**: GitHub Actions
- **Testing**: Python, pytest

## 🔧 Commands

```bash
# Development
pnpm dev          # Start dev server
pnpm build        # Build for production
pnpm check        # Type check

# Infrastructure
terraform init
terraform plan
terraform apply

# Testing
pytest            # Run tests
```

---
