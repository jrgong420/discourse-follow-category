import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";
import { i18n } from "discourse-i18n";
import CategoryNotificationsDropdownButton from "../components/category-notifications-dropdown-button";

export default class FollowCategoryButton extends Component {
  @service currentUser;
  @tracked isAnimating = false;

  get indirectlyMutedCategoryIds() {
    return this.currentUser?.indirectly_muted_category_ids || [];
  }

  get categoryNotificationLevel() {
    if (this.indirectlyMutedCategoryIds.includes(this.args.model.id)) {
      return NotificationLevels.MUTED;
    } else {
      return this.args.model?.get("notification_level");
    }
  }

  get showFollowButton() {
    return (
      this.args.model?.get("notification_level") === NotificationLevels.NORMAL
    );
  }

  get buttonClasses() {
    let classes = "follow-category-button btn-default";
    if (this.isAnimating) {
      classes += " bell-ring";
    }
    return classes;
  }

  @action
  changeCategoryNotificationLevel(notificationLevel) {
    this.args.model?.setNotification(notificationLevel);
  }

  @action
  followCategory() {
    // Prevent multiple rapid clicks during animation
    if (this.isAnimating) {
      return;
    }

    // Trigger animation immediately
    this.isAnimating = true;

    // Set notification level
    this.args.model?.setNotification(NotificationLevels.WATCHING_FIRST_POST);

    // Clean up animation class after duration (800ms to match CSS)
    setTimeout(() => {
      this.isAnimating = false;
    }, 800);
  }

  <template>
    {{#if @model}}
      {{#if this.showFollowButton}}
        <DButton
          @action={{this.followCategory}}
          @icon="bell"
          @translatedLabel={{i18n (themePrefix "follow_category_button_title")}}
          class={{this.buttonClasses}}
        />
      {{else}}
        <CategoryNotificationsDropdownButton
          @value={{this.categoryNotificationLevel}}
          @category={{@model}}
          @onChange={{this.changeCategoryNotificationLevel}}
        />
      {{/if}}
    {{/if}}
  </template>
}
