"""Oryx GraphQL API client for fetching layout data."""

from __future__ import annotations

import json
from typing import Any

import requests

GRAPHQL_URL: str = "https://oryx.zsa.io/graphql"
KEYBOARD_GEOMETRY: str = "voyager"

_FULL_LAYOUT_QUERY = """
query GetLayout($hashId: String!, $revisionId: String!, $geometry: String!) {
  layout(hashId: $hashId, revisionId: $revisionId, geometry: $geometry) {
    hashId
    title
    revision {
      hashId
      model
      layers {
        position
        title
        keys
      }
    }
  }
}
"""


def _graphql(query: str, variables: dict[str, Any]) -> dict[str, Any]:
    """Execute a GraphQL query and return the data payload."""
    response = requests.post(
        GRAPHQL_URL,
        json={"query": query, "variables": variables},
        headers={"Content-Type": "application/json"},
        timeout=30,
    )
    response.raise_for_status()
    body = response.json()

    if "errors" in body:
        raise RuntimeError(f"GraphQL errors: {json.dumps(body['errors'], indent=2)}")

    return body["data"]


def fetch_layout(layout_id: str) -> dict[str, Any]:
    """
    Fetch the latest layout from the Oryx API.

    Args:
        layout_id: The Oryx layout hash ID (e.g. "QJ07g").

    Returns:
        Full layout object including revision and layers.
    """
    # "latest" works directly as revisionId, no prefetch step needed to resolve it
    data = _graphql(_FULL_LAYOUT_QUERY, {
        "hashId": layout_id,
        "revisionId": "latest",
        "geometry": KEYBOARD_GEOMETRY,
    })
    return data["layout"]
