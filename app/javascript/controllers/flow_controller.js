// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import {Controller} from "stimulus"

export default class extends Controller {

    static targets = ["container", "more"];

    loadMore(e) {
        e.preventDefault()
        let next_page = $(e.currentTarget).data('next-page')
        let url = this.updateURLString(window.location.href, next_page);
        let ctx = this;
        $.ajax({
            type: "GET",
            url: url,
            dataType: 'json',
            cache: false,
            success: function (json) {
                let html = json['html']
                $(ctx.moreTarget).replaceWith(html)
                // let next_start = json['next_start']
                // let next_post_id = json['next_post_id']
                // let next_article_id = json['next_article_id']
                // $(ctx.element).data('next-post-id', next_post_id)
                // $(ctx.element).data('next-start', next_start)
                // $(ctx.element).data('next-article-id', next_article_id)
            },
        });

    }

    updateURLString(urlStr, next_page) {
        let url = new URL(urlStr);

        let query_string = url.search;

        let search_params = new URLSearchParams(query_string);

        search_params.set('page', next_page);

        url.search = search_params.toString();

        return url.toString();
    }

}
