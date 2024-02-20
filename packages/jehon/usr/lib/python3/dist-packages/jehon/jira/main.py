#
# PAT (token):
#   https://jira.blablabla/secure/ViewProfile.jspa?selectedTab=com.atlassian.pats.pats-plugin:jira-user-personal-access-tokens
#

from typing import cast, Any, Optional, List
import yaml

from jira import JIRA, Issue

class JJira:
    """ An authentified JIRA client """
    client: JIRA

    def __init__(self, crendentials: str):
        with open(f"/etc/jehon/restricted/{crendentials}.yaml", "r", encoding='utf-8') as stream:
            config = yaml.safe_load(stream)
            self.client = JIRA(config.get('url'), token_auth=config.get('token'))

    def get_issues(self, jql: str, fields: Optional[List[str]] = None) -> List[Issue]:
        """ List issues and send back a real list

            https://jira.readthedocs.io/examples.html#issues
        """

        issues: List[Issue] = []
        i = 0
        chunk_size = 100
        while True:
            chunk = cast(
                dict[str, Any],
                self.client.search_issues(jql, startAt=i, maxResults=chunk_size, fields = fields)
            )
            i += chunk_size
            issues += cast(List[Issue], chunk.iterable) # type: ignore[attr-defined]
            if i >= chunk.total: # type: ignore[attr-defined]
                break
        return issues

    def print_issues(self, issues: List[Issue]) -> None:
        """ Pretty print issues list

            key: [component,component,...] Summary
        """

        for i in issues:
            print(i.key, end="")
            print(": ", end="")
            if hasattr(i.fields, "components"):
                print(" [", end="")
                print(",".join({ c.name for c in i.fields.components}), end="")
                print("] ", end="")
            print(i.fields.summary, end="")
            print()
