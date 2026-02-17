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

  static shouldShow() {
    // eslint-disable-next-line no-console
    console.log(this.args.category.read_restricted);
    return this.args.category.read_restricted
  }

  async fetchAllGroups() {
    const res = ajax(`/c/${this.args.category.id}/visible_groups.json`);
    this.groups_list = res["groups"];
    // eslint-disable-next-line no-console
    console.log(this.groups_list);
  }

  get maxGroupCount() {
    this.groups_list.length - 1;
  }

  <template>
    <span>
      <DTooltip class="btn btn-icon" @placement="top-end" @interactive={{true}}>
        <:trigger>
          {{icon "circle-info"}}
        </:trigger>
        <:content>
          <div>
            {{i18n (themePrefix "allowed_groups_text")}}
            {{#each this.groups_list as |group index|}}
              {{group}}{{if (lt index this.maxGroupCount) ", "}}
            {{/each}}
          </div>
        </:content>
      </DTooltip>
    </span>
  </template>
}
