# FLUX Prompt Patterns

## Hero Section Images

**SaaS Dashboard Hero:**
```
A clean, modern SaaS dashboard interface screenshot showing analytics charts,
data visualization with gradient purple and blue colors, minimalist UI design,
white background, professional software product screenshot
```
- Model: `flux-2-pro` | Size: 1920x1080

**Abstract Tech Hero:**
```
Abstract geometric shapes flowing in a wave pattern, gradient from deep purple
to electric blue, minimal design, tech-inspired, clean white space, modern
digital art style suitable for a SaaS website hero section
```
- Model: `flux-2-pro` | Size: 1440x810

**Team/People Hero:**
```
Diverse team of professionals collaborating around a modern desk with laptops,
natural lighting, clean office environment, soft bokeh background, professional
corporate photography style, warm and inviting atmosphere
```
- Model: `flux-2-max` | Size: 1920x1080

## Dashboard Mockups

**Analytics Dashboard:**
```
Screenshot of a modern web application dashboard, dark sidebar navigation,
main content area with line charts and bar charts, metric cards showing KPIs,
clean minimal design, professional UI, Tailwind CSS style
```
- Model: `flux-2-pro` | Size: 1440x900

**Settings Page:**
```
Screenshot of a clean settings page in a SaaS application, left navigation
with sections, form fields on the right, toggle switches, save button,
modern minimal UI design, light theme, professional software product
```
- Model: `flux-2-klein-9b` | Size: 1280x800

## Icon Generation

**App Icon:**
```
Minimal app icon design, geometric letter [X] shape, gradient from [#6366f1]
to [#8b5cf6], rounded square background, flat design, modern tech startup
logo style, clean vector-like rendering
```
- Model: `flux-2-pro` | Size: 512x512

**Feature Icons:**
```
Minimal line icon of [concept], single color [#6366f1], white background,
clean geometric style, suitable for a SaaS product feature section,
simple and recognizable
```
- Model: `flux-2-klein-9b` | Size: 512x512

## OG Images (Social Sharing)

**Product OG Image:**
```
Clean social media preview card for "[Product Name]" SaaS product,
product screenshot floating at an angle with subtle shadow, gradient
background from dark blue to purple, product name in bold white text,
tagline underneath, modern tech marketing design
```
- Model: `flux-2-flex` (for text) | Size: 1200x630

## Abstract Backgrounds

**Gradient Mesh:**
```
Soft gradient mesh background, flowing organic shapes, colors blending
from [#6366f1] through [#8b5cf6] to [#ec4899], subtle noise texture,
modern abstract design, suitable for website section background
```
- Model: `flux-2-klein-9b` | Size: 1920x1080

**Geometric Pattern:**
```
Subtle geometric pattern background, repeating hexagonal grid, very light
gray lines on white background, minimal and clean, suitable for a
professional SaaS website background, barely visible pattern
```
- Model: `flux-2-klein-9b` | Size: 1920x1080

## API Usage Pattern

```bash
# 1. Submit generation request
RESPONSE=$(curl -s -X POST "https://api.bfl.ai/v1/flux-2-pro" \
  -H "x-key: $BFL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "YOUR_PROMPT_HERE", "width": 1920, "height": 1080}')

# 2. Extract polling URL
POLL_URL=$(echo $RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin)['polling_url'])")

# 3. Poll until ready (wait 5-10 seconds between polls)
sleep 8
RESULT=$(curl -s "$POLL_URL" -H "x-key: $BFL_API_KEY")
STATUS=$(echo $RESULT | python3 -c "import sys,json; print(json.load(sys.stdin).get('status',''))")

# 4. Download when status is "Ready"
if [ "$STATUS" = "Ready" ]; then
  IMAGE_URL=$(echo $RESULT | python3 -c "import sys,json; print(json.load(sys.stdin)['result']['sample'])")
  curl -s -o output.png "$IMAGE_URL"
  echo "Image saved to output.png"
fi
```
