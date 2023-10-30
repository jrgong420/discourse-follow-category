import { createWidget } from "discourse/widgets/widget";
import { hbs } from "ember-cli-htmlbars";
import RenderGlimmer from "discourse/widgets/render-glimmer";

createWidget("follow-category", {
  html(attrs) {
    return [
      new RenderGlimmer(
        this,
        "div.category-follow-button",
        hbs`<FollowCategoryButton @model={{@data.attrs}} />`,
        {
          attrs,
        }
      ),
    ];
  },
});
