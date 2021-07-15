import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "th_template", "add_column", "td_template", "add_row", "head_row", "rows" ]

  add_column(event) {
    var column_count = this.head_rowTarget.childElementCount - 3

    var th = this.th_templateTarget.innerHTML
    this.add_columnTarget.insertAdjacentHTML("beforebegin", th)

    var rows = this.rowsTarget
    var row_count = this.rowsTarget.childElementCount - 2
    for (let i = 1; i <= row_count; i++) {
      var td = this.td_templateTarget.innerHTML.replace(/NEW_ROW/g, row_count + i).replace(/NEW_COL/g, column_count + 1)
      rows.children[i].innerHTML += td
    }
  }

  add_row(event) {
    var row_count = this.rowsTarget.childElementCount - 2

    var row = document.createElement("tr")

    var number_cell = document.createElement("td")
    var number = document.createTextNode(row_count + 1)
    number_cell.appendChild(number)
    row.appendChild(number_cell)

    var column_count = this.head_rowTarget.childElementCount - 3
    for (let i = 1; i <= column_count; i++) {
      var td = this.td_templateTarget.innerHTML.replace(/NEW_ROW/g, row_count + 1).replace(/NEW_COL/g, i)
      row.innerHTML += td
    }

    this.add_rowTarget.insertAdjacentElement("beforebegin", row)
  }

}
