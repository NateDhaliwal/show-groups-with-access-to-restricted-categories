import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import DTooltip from "discourse/float-kit/components/d-tooltip";
import icon from "discourse/helpers/d-icon";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";
import { lt } from "truth-helpers";

export default class ShowTooltipButton extends Component {
  @tracked
  groups_list = [];

  constructor() {
    super(...arguments);
    this.fetchAllGroups();
  }

  get shouldShow() {
    return this.args.category.read_restricted
  }

  async fetchAllGroups() {
    const res = await ajax(`/c/${this.args.category.id}/visible_groups.json`);
    this.groups_list = res["groups"];
  }

  get maxGroupCount() {
    this.groups_list.length - 1;
  }

  <template>
    {{#if this.shouldShow}}
      <DTooltip class="btn btn-icon" @icon="circle-info">
        <div>
          {{i18n (themePrefix "allowed_groups_text")}}
          {{#each this.groups_list as |group index|}}
            {{group}}{{if (lt index this.maxGroupCount) ", "}}
          {{/each}}
        </div>
      </DTooltip>
    {{/if}}
  </template>
}
