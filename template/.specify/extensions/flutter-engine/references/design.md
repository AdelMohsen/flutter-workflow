# Design synchronization contract

Accept Figma MCP, a Figma URL/node, token JSON, exported assets/styles, manual
values, or `Not available yet`. Normalize the selected source into
`.specify/flutter-engine/design/design-contract.json`; production code consumes
project theme/tokens, not the source format.

If Figma MCP is unavailable, expired, or lacks access, state that connection is
not ready and offer reconnect/another URL, JSON, exports, manual values, or
skip. Never request or store access credentials in the repository. A deferred
design source never blocks feature discovery.

Before applying a sync, compare tokens/components and list affected consumers in
the plan. Preserve project-specific intentional overrides. Use semantic colors,
typography, spacing, radii, elevations, breakpoints, directionality, and asset
references; do not translate raw Figma positioning into brittle Flutter code.
