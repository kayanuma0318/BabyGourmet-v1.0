import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  // タブの初期化
  connect() {
    const urlParams = new URLSearchParams(window.location.search)
    const currentTab = urlParams.get('tab') || this.tabTargets[0].dataset.tab
    const tabButton = this.tabTargets.find(tab => tab.dataset.tab === currentTab)
    if (tabButton) {
      this.switchTab(tabButton, false)
    } else {
      this.switchTab(this.tabTargets[0], false)
    }
  }
    // 1行目: URLパラメータを取得するために URLSearchParams というオブジェクトを作成
    // 2行目左側: URLから tab パラメータを取得(tab = パラメータ名)
    // 2行目右側: もし、tab パラメータが存在しない場合は、初期タブのdata-tab属性の値を使用する（初期タブの表示 = current_tab）
    // 3行目: current_tabと同じ名前のタブを探す
    // 3-1行目 : もし、current_tabと同じ名前のタブが見つかれば、そのタブを表示する(false = アドレスを変更しない)
    // 3-2行目 : もし、current_tabと同じ名前のタブが見つからなければ、初期タブを表示する

  // タブがクリックされた時の処理
  switch(event) {
    event.preventDefault()
    const selectedTab = event.currentTarget
    this.switchTab(selectedTab, true)
  }
  // 1行目: クリックした際にページが遷移しないようにする
  // 2行目: クリックしたタブを覚えておく
  // 3行目: クリックされたタブを表示し、アドレスを変更する(true = アドレスを変更する)

  // タブを切り替える処理
  switchTab(tab, updateURL) {
    this.tabTargets.forEach((t) => {
      t.classList.remove("text-blue-600", "border-blue-600", "border-b-2")
      t.classList.add("hover:text-gray-600", "hover:border-gray-300", "border-b")
      t.setAttribute("aria-selected", "false")
    })
    tab.classList.add("text-blue-600", "border-blue-600", "border-b-2")
    tab.classList.remove("hover:text-gray-600", "hover:border-gray-300", "border-b")
    tab.setAttribute("aria-selected", "true")
    // 1行目: eachで全てのタブを非選択状態にする
    // 2行目: 青い文字と青い線を削除
    // 3行目: ホバー時に薄い灰色になるように設定
    // 4行目: aria-selectedをfalseに設定し、選択されていないことを明示化する

    // クリックされたタブを選択状態にする
    // 1行目: 青い文字と青い線を追加
    // 2行目: ホバー時の設定を削除
    // 3行目: aria-selectedをtrueに設定し、選択されていることを明示化する

    // コンテンツ内容の表示
    this.contentTargets.forEach((c) => {
      c.classList.add("hidden")
    })

    const contentId = tab.getAttribute("data-tab")
    const content = this.contentTargets.find((c) => c.id === contentId)
    if (content) {
      content.classList.remove("hidden")
    }

    if (updateURL) {
      const url = new URL(window.location)
      url.searchParams.set('tab', contentId)
      window.history.replaceState({}, '', url)
    }
    // 1区画: 全てのコンテンツを非表示にする
    // 2区画-1行目: クリックされたタブの名前(data-tab)を取得する
    // 2区画-2行目: その名前と同じ名前のコンテンツを探す
    // if(content): もし、その名前のコンテンツが見つかれば、hiddenを削除して表示する
    // if(updateURL): switchTabの引数(updateURL)がtrueの場合は、以下の処理をする
    //                   : 1行目: 現状のURL(window.location)を取得し、新しいURLを作成する
    //                   : 2行目: URLのパラメータを更新する(~(略).com?tab=contentId('yummy'等))
    //                   : 3行目: ページをリロードせずに、アドレスバーのURLを新しいURLに変更する
    //                   :     : {}空のオブジェクトを使用することで状態を保存しないことを意味する
    //                   : 　　 : 2番目の引数''は、ページのタイトルを変更するためのもの(多くのブラウザでは無視されるらしい)
    //                   : 　　 : 3番目の引数urlは、新しいURLを指定する
  }
}
