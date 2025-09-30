---
title: "Hello, world"
date: 2025-01-31
author: WP Team
summary: A first post written in Markdown. Includes images, video, and code.
layout: post.njk
tags: posts
---

Welcome to the blog! You can write in **Markdown**, add images, and embed media.

### Image

![Ortahisar](../../images/places/ortahisar.jpg)

*(Tip: you can also copy images into `blog/assets/` and reference them as `/news/assets/...` after build.)*

### YouTube embed

{% youtube "dQw4w9WgXcQ" %}

### Code blocks (R and Python)

```r
x <- c(1,2,3)
mean(x)
```

```python
import statistics as st
st.mean([1, 2, 3])
```