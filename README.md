# SMS-Event-Reminders

Add a brief description of this project here, in Markdown format.
It will be shown on the main page of the project's GitHub repository.

## Development
1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev` to deploy this project.
3. Run `cci org browser dev` to open the org in your browser.

## Release
1. Release a Beta Version
```bash
cci flow run release_unlocked_beta --org dev
```

2. Test Deploy the Beta Version
```bash
cci flow run ci_beta --org beta
```

3. Promote to a Production Version. ***This promotes the latest beta version by default***
```bash
cci flow run release_unlocked_production --org release
```