---
liquid: true
---

FEEDBACK_URL = "{{ site.feedback_link }}?entry.1117270848="
FEEDBACK_TEMPLATE = """=== BUG ===

Summary:
<summarize bug here>

Steps to reproduce:
<summarize what you did up to and including when the bug reared its ugly head>

Additional notes:
<any additional stuff you want to add>"""
FEEDBACK_BUG_ADDON = "&entry.2071656823=#{encodeURIComponent(FEEDBACK_TEMPLATE)}"

body = document.body

isMobile = () -> /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test((navigator.userAgent||navigator.vendor).substr(0,4))

frustrationCount = 0
frustrationTimeout = null
frustrationKeys = []

displayModal = (calmdown, please, futext, oktext, addbuttons = [{ url: FEEDBACK_URL + encodeURIComponent(location.href) + FEEDBACK_BUG_ADDON, text: "I'd like to fill out a bug report!"}]) ->
  addbuttons = addbuttons.map (btn) -> "<p><a class='button' href='#{btn.url}' target='_blank'>#{btn.text}</a></p>"
  modal = """<div id="feedback-modal">
<div id="feedback-modal-bg" onclick="event.preventDefault();document.body.removeChild(document.getElementById('feedback-modal'))"></div>
<div id="feedback-modal-wrapper">
  <div id="feedback-modal-content">
    <h2>#{calmdown}</h2>
    <p>#{please}</p>
    <p class="login-note">(Please note: you must be signed into a YRDSB Gapps account in order to fill out the form.)</p>
    <div class="buttons">
      <p><a class="button button-primary" href="#{FEEDBACK_URL}#{encodeURIComponent(location.href)}" target="_blank">#{futext}</a></p>
      #{addbuttons.join("\n")}
      <p><a href="#" onclick="event.preventDefault();document.body.removeChild(document.getElementById('feedback-modal'))">#{oktext}</a></p>
    </div>
  </div>
</div>
</div>"""
  body.insertAdjacentHTML "beforeend", modal

window.FEEDBACKDisplayModal = () ->
  displayModal "Thanks for participating!",
    "We're so glad you decided to tell us what you think of our new website.",
    "I have something to say!",
    "Not today, just came here by accident."

frustrationHandler = (oktext, opts = []) ->
  displayModal "Looks like you're frustrated.",
    "We're sorry we ticked you off. Would you like to tell us what we did wrong?",
    "Yes, please!",
    oktext ? "No, I'm fine.",
    opts

window.addEventListener "keydown", (e) ->
  if e.target.tagName == "INPUT" or e.target.tagName == "TEXTAREA" or e.target.hasAttribute('contenteditable') or e.altKey or e.ctrlKey or e.metaKey or e.shiftKey
    return null

  if -1 == frustrationKeys.indexOf e.keyCode
    frustrationKeys.push e.keyCode
    frustrationCount += 1
    clearTimeout frustrationTimeout
    frustrationTimeout = setTimeout (() -> frustrationCount = 0), 100

  if frustrationCount > 3 and document.querySelectorAll('#feedback-modal').length == 0
    frustrationHandler "I'm fine, my cat just stepped on my keyboard."
    frustrationCount = 0

window.addEventListener "keyup", (e) ->
  if e.target.tagName == "INPUT" or e.target.tagName == "TEXTAREA" or e.target.hasAttribute('contenteditable') or e.altKey or e.ctrlKey or e.metaKey or e.shiftKey
    return null
  frustrationKeys = []
  frustrationCount = if frustrationCount > 0 then frustrationCount - 1 else 0

document.querySelector("head").insertAdjacentHTML "beforeend", "
<style>
#open-feedback-modal {
  position: fixed; bottom: 20px; right: 20px;
  box-sizing: border-box; width: 160px; height: 50px;
  background-color: #f52f2f; color: white;
  line-height: 50px; font-size: 20px; font-weight: 700; text-align: center;
  border-radius: 50px; box-shadow: 0 0 20px rgba(0, 0, 0, .5), 0 2px 5px rgba(0, 0, 0, .4);
  transition: .3s ease;
}
#open-feedback-modal:hover {
  background-color: #f75858;
  text-decoration: none;
  box-shadow: 0 0 20px rgba(0, 0, 0, .5), 0 5px 10px rgba(0, 0, 0, .4);
}
#feedback-modal-bg {
  position: fixed; top: 0; bottom: 0; left: 0; right: 0;
  background: rgba(0, 0, 0, .7);
  z-index: 10;
}
#feedback-modal-wrapper {
  position: fixed; top: 50%; left: 50%;
  width: 60%; max-width: 800px; max-height: 75%;
  background-color: white;
  padding: 40px; border-radius: 15px; margin: auto;
  z-index: 10; overflow-y: auto;
  transform: translateX(-50%) translateY(-50%);
}
.theme-dark #feedback-modal-wrapper { background-color: #1a1f2a; }
#feedback-modal .login-note { font-size: .95em; }
@media (max-width: 768px) { #feedback-modal .login-note { display: none; } }
#feedback-modal .button { width: 100%; }
#feedback-modal .buttons p {
  font-size: 1.1em; text-align: center;
  margin-bottom: 0;
}
#feedback-modal .button:not(.button-primary) {
  color: #f52f2f;
  border-color: rgba(245, 47, 47, .6);
}
#feedback-modal .button:not(.button-primary):hover { border-color: #f52f2f; }
</style>
"
body.insertAdjacentHTML "beforeend", """<a id='open-feedback-modal' href='#' title='Give feedback' onclick='event.preventDefault();FEEDBACKDisplayModal()'>Give feedback</a>"""
