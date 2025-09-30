// .eleventy.js (at repo root)
import pluginSyntaxHighlight from "@11ty/eleventy-plugin-syntaxhighlight";

export default function (eleventyConfig) {
  // Optional: code highlighting for fenced blocks ```js etc.
  eleventyConfig.addPlugin(pluginSyntaxHighlight);

  // We don’t need to copy your /assets or /images because posts can reference
  // the existing site assets at /assets/... and /images/...
  // But if you put post-specific images inside blog/posts/**, copy them too:
  eleventyConfig.addPassthroughCopy({ "blog/posts": "news/posts" });

  return {
    // Tell Eleventy that the source content is in /blog and output to /news
    dir: {
      input: "blog",
      includes: "_includes",
      layouts: "_layouts",
      output: "news"
    },
    templateFormats: ["njk", "md"],
    htmlTemplateEngine: "njk",
    markdownTemplateEngine: "njk",
    pathPrefix: "/"
  };
}
