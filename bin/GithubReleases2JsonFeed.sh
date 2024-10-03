# required programs check
HAS_CURL=$(which curl >/dev/null 2>&1 && echo 1 || echo 0)
HAS_JQ=$(which jq >/dev/null 2>&1 && echo 1 || echo 0)
if [ $HAS_CURL -eq 0 ] || [ $HAS_JQ -eq 0 ]; then
  echo >&2 "curl and jq is required."
  exit 1
fi

# see: https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#list-releases--status-codes
# interesting keys:
# - id: string
# - name: string
# - html_url: string
# - body: string
# - published_at: date
# - draft: bool
# - prerelase: bool

REPO="${1:-libsdl-org/SDL}"
TITLE="${2:-SDL Releases}"
PAGE=1
PER_PAGE=3

FILTER=$(cat <<EOF
{
  version: .[0].html_url | split("/")[:-2] | join("/"),
  title: "$TITLE",
  home_page_url: .[0].html_url | split("/")[:-3] | join("/"),
  feed_url: .[0].html_url | split("/")[:-2] | join("/"),
  items: map({
    id: .id,
    date_published: .published_at,
    title: .name,
    url: .html_url,
    content_text: .body
  })
}
EOF
)

exec curl -sSL "https://api.github.com/repos/$REPO/releases?page=$PAGE&per_page=$PER_PAGE" | jq -c "$FILTER"
