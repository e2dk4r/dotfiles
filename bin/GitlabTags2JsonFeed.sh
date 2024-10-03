# https://gitlab.freedesktop.org/-/graphql-explorer

# curl 'https://gitlab.freedesktop.org/api/graphql' \
#   -X POST \
#   -H 'Content-Type: application/json' \
#   -o test.json \
#   --data-binary @- << EOF
# 
# query ls($project: ID!, $branch: String = "main", $path: String!, $pageSize: Int = 100, $cursor: String) {
#   project(fullPath: $project) {
#     repository {
#       tree(ref: $branch, path: $path) {
#         blobs(first: $pageSize, after: $cursor) {
#           pageInfo {
#             hasNextPage
#             endCursor
#           }
#           edges {
#             node {
#               name
#               path
#               sha
#             }
#           }
#         }
#       }
#     }
#   }
# }
# {
#   "project": "mesa/mesa",
#   "path": "docs/relnotes",
#   "cursor": "MzAw"
# }
# 
# query cat($project: ID!, $branch: String = "main", $paths: [String!]!) {
#   project(fullPath: $project) {
#     repository {
#       blobs(ref: $branch, paths: $paths) {
#         edges {
#           node {
#             rawBlob,
#           }
#         }
#       }
#     }
#   }
# }
# 
# {
#   "project": "mesa/mesa",
#   "paths": [
#     "docs/relnotes/23.3.1.rst",
#     "docs/relnotes/23.3.2.rst"
#   ]
# }
# EOF

DOMAIN="${1:-gitlab.freedesktop.org}"
REPO="${2:-mesa/mesa}"

FILTER=$(cat <<EOF
{
  version: .[0].commit.web_url | split("/")[:-3] | join("/"),
  home_page_url: .[0].commit.web_url | split("/")[:-3] | join("/"),
  items: map({
    id: .commit.id,
    date_published: .commit.created_at,
    title: .name,
    url: "https://$DOMAIN/$REPO/-/tags/\(.name)",
    content_text: .body
  })
}
EOF
)

urlEncodedRepo=$(echo -n ${REPO} | jq --slurp --raw-input --raw-output @uri)
exec curl -sSL "https://$DOMAIN/api/v4/projects/$urlEncodedRepo/repository/tags?search=&per_page=10" | jq -c "$FILTER"
