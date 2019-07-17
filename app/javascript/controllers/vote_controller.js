// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "score", "essayId", "essayType"]

  vote(e) {
    e.preventDefault()
    let ctx = this
    let data = {
      essay_id: this.essayIdTarget.value,
      essay_type: this.essayTypeTarget.value,
    }
    data = Object.assign(data, this.csrfParam())
    $.ajax({
      type: "POST",
      url: "/votes",
      data: data,
      cache: false,
      dataType: 'json',
      success: function(data){
        $(ctx.scoreTarget).text(data['score'])
      }
    });
  }

  csrfParam() {
    let param = $('meta[name="csrf-param"]').attr('content');
    let value = $('meta[name="csrf-token"]').attr('content');
    let ret = {}
    ret[param] = value
    return ret
  }
}
