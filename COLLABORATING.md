## Collaborating

1. Before you proceed, enable the hooks from `.githooks/` directory:

```bash
git config --local core.hooksPath .githooks
```

2. Provide clear descriptions for new or updated variables and/or outputs. For `object` variables, make sure your description is a multiline string with every attribute on the new line:

```hcl
variable "test" {
  type = object({
    hello = string
    world = optional(string, "foo")
  })
  default  = null
  nullable = true
  description = <<DESCRIPTION
Test variable
  hello - dummy variable
  world - sometimes in use
DESCRIPTION
}
```

Note the sub-parameters, their descriptions are parsed by release manager so must have specific formatting:

  * indentation is mandatory (at least two spaces)
  * ` - ` between the parameter name and its description

For `map(object)` make sure to specify a literal `<key>` parameter in your description:

```hcl
variable "items" {
  type = map(object({
    hello = string
    world = optional(string, "foo")
  }))
  default  = null
  nullable = true
  description = <<DESCRIPTION
Items variable
  <key> - name of the item
  hello - dummy variable
  world - sometimes in use
DESCRIPTION
}

```

> If for some reason you need to define a table of variables or outputs manually, create `INPUTS.md` or `OUTPUTS.md`:

| Variable | Description | Type | Default | Required | Sensitive |
| -------- | ----------- | ---- | ------- | -------- | --------- |
|          |             |      |         |          |           |

| Output | Description | Type | Sensitive |
| ------ | ----------- | ---- | --------- |
|        |             |      |           |

> If you do so, you must keep them up-to-date with data in `variables.tf` and `outputs.tf` with every PR.

3. Keep `.terraform.lock.hcl` checked out and up-to-date!

4. Provide examples in `examples/` directory:

  + one directory per example, with example title in its name (`custom_setup_with_extra_features/`)
  + example-specific directory must contain at least `main.tf` and `README.md` inside
  + in `README.md`, a new line with the name of the file indicates where this file's content must be placed:

    ```markdown
    Example description with some notes
    
    main.tf
    
    > Another note you desperately wanted to add after the example
    ```

5. Update the diagram in `docs/diagram.drawio` and export it as 100% size into `docs/diagram.png` 

6. Update `CHANGELOG.md` prior to merging a PR: the most recent version is on top, plus the list of changes since the previous one - use [Keep a Changelog format](https://keepachangelog.com/en/1.0.0/).

7. If your changes are incompatible with the previous major version, write an entry in `UPGRADE_NOTES.md` in the following format:

```markdown
### From v1.x to v2.x

Your recommendations, manual actions, commands and any useful instructions.
```

8. The project follows [Semantic Versioning](https://semver.org/) - add a `git` tag with `X.Y.Z` version after the merge.

## Links

* [Terraform Modules Documentation](https://www.terraform.io/docs/modules/index.html)
* [Terraform naming conventions](https://www.terraform-best-practices.com/naming)
* [Terraform version constraints](https://www.terraform.io/language/expressions/version-constraints)
