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

  static targets = [ "more", 'form', 'formCommentInput']

  addComment(e) {
    e.preventDefault();
    let values = $(this.formTarget).serializeArray()
    let body = this.objectifyForm(values);
    let ctx = this;
    $.ajax({
      type: "POST",
      url: "/comments",
      data: body,
      dataType: 'json',
      cache: false,
      success: function(json){
        let html = json['html']
        $(ctx.element).prepend(html)
        alert('提交成功')
        ctx.removeReplyInfo()
        $(ctx.formCommentInputTarget).val('')
      },
      error: function () {
        alert("评论提交失败");
      }
    });
  }

  objectifyForm(formArray) {//serialize data function

    var returnArray = {};
    for (var i = 0; i < formArray.length; i++){
      returnArray[formArray[i]['name']] = formArray[i]['value'];
    }
    return returnArray;
  }

  addReplyInfo(e) {
    e.preventDefault()
    let element = $(e.currentTarget);
    let replyId = element.data("comment-id")
    let replyUsername = element.data("comment-username")
    $('<input>').attr({
      type: 'hidden',
      id: 'reply-to-comment-id',
      name: 'reply_to_comment_id',
      value: replyId,
    }).appendTo(this.formTarget);
    $('<a>取消回复</a>').attr({
      id: 'dis-reply-comment',
      "data-action": "comments#removeReplyInfo",
    }).appendTo(this.formTarget);
    $('<a>' + replyUsername + '</a>').attr({
      id: 'reply-comment-username',
      name: 'reply_comment_username',
    }).appendTo(this.formTarget);
  }

  removeReplyInfo(e) {
    if (e) {
      e.preventDefault()
    }
    $(this.formTarget).find("#reply-to-comment-id").remove()
    $(this.formTarget).find("#reply-comment-username").remove()
    $(this.formTarget).find("#dis-reply-comment").remove()
  }

  fetchMore(e) {
    e.preventDefault()
    let element = $(e.currentTarget)
    let start = element.data('start')
    let essayId = element.data('essay-id')
    let essayType = element.data('essay-type')
    let dataStr = `essay_id=${essayId}&essay_type=${essayType}&start=${start}`
    let ctx = this;
    $.ajax({
      type: "GET",
      url: "/comments",
      data: dataStr,
      dataType: 'json',
      cache: false,
      success: function(json){
        let html = json['html']
        $(ctx.moreTarget).replaceWith(html);
      }
    });
  }

}
