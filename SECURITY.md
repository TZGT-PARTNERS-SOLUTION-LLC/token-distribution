# Security Policy

## Reporting a Vulnerability

We take security vulnerabilities in the token-distribution project seriously. If you discover a security vulnerability, please follow responsible disclosure practices.

### Do Not

- Create a public GitHub issue for security vulnerabilities
- Post vulnerability details on public forums or channels
- Attempt to exploit any vulnerability you discover

### Do

Please report security vulnerabilities by:

1. **Email**: Contact the maintainers directly with details about the vulnerability
2. **GitHub Security Advisory**: Use GitHub's private vulnerability reporting feature by navigating to the Security tab and selecting "Report a vulnerability"

When reporting, please include:
- A clear description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Any suggested fixes or patches (if available)

### Response Timeline

- We acknowledge receipt of vulnerability reports within 48 hours
- We work to understand and reproduce the vulnerability
- We develop and test a fix
- We release a patched version and provide credit to the reporter (if desired)

We appreciate your help in keeping this project secure.

## Supported Versions

The following versions are currently supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | ✅ Yes             |
| < 1.0   | ❌ No              |

## Security Best Practices

When using this project:

- Keep dependencies up to date
- Review security advisories regularly
- Use environment variables for sensitive configuration (see `.env.example`)
- Never commit secrets to the repository
- Follow secure development practices when contributing

## Dependabot Alerts

This repository uses GitHub's Dependabot to monitor dependencies for known vulnerabilities. We review and address security alerts promptly.

## Additional Resources

- [GitHub Security Lab](https://securitylab.github.com/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
