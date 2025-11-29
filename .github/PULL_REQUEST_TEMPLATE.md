## Description

<!-- Provide a clear and concise description of your changes -->

## Type of Change

<!-- Mark the relevant option with an "x" -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Configuration change
- [ ] Refactoring (no functional changes)

## Affected Hosts

<!-- List the hosts affected by these changes -->

- [ ] All hosts
- [ ] Specific host(s): <!-- specify which hosts -->

## Checklist

<!-- Mark completed items with an "x" -->

- [ ] I have tested this change locally
- [ ] I have run `nix flake check` and all checks pass
- [ ] I have run `nix fmt` to format the code
- [ ] I have updated documentation (if applicable)
- [ ] My code follows the style guidelines of this project
- [ ] My commits follow the conventional commits format
- [ ] I have tested on the affected host(s) if possible

## Testing

<!-- Describe how you tested your changes -->

```bash
# Commands used for testing
nix flake check
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
# etc.
```

## Screenshots (if applicable)

<!-- Add screenshots to demonstrate visual changes -->

## Additional Context

<!-- Add any other context about the pull request here -->

## Related Issues

<!-- Link any related issues -->

Closes #
Related to #
