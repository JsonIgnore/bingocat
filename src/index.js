

function docReady(fn) {
    // see if DOM is already available
    if (document.readyState === "complete" || document.readyState === "interactive") {
        // call on next available tick
        setTimeout(fn, 1);
    } else {
        document.addEventListener("DOMContentLoaded", fn);
    }
}

function selectSpace(el) {
	el.classList.add("bingoed");
}

function generateCard() {
	console.log("rage quitting")
	const termset_id = document.getElementById('parent_termset').innerHTML
	if (termset_id) {
		window.location.assign(`/generate/${termset_id}`)		
	} else {
		window.location.assign('/')
	}

}

function addTerms() {
	console.log("trolling")
	const termset_id = document.getElementById('parent_termset').innerHTML
	if (termset_id) {
		window.location.assign(`/terms/${termset_id}`)
	} else {
		window.location.assign('/create')
	}
}

docReady(function() {
	const columns = ["1", "2", "3", "4", "5"]
	const rows = ["a", "b", "c", "d", "e"]

	columns.forEach((col) => {
		rows.forEach((row) => {
			if (col === "3" && row === "c") {
				const el = document.getElementById(`space-${row}-${col}`)

				selectSpace(el)
			} else {
				document.getElementById(`space-${row}-${col}`).addEventListener("click", (e) => {
					selectSpace(e.target)
				})
			}
		})
	})

	var gen = document.getElementById("generate").addEventListener("click", generateCard)
	var share = document.getElementById("share").addEventListener("click", addTerms)
	

  // DOM is loaded and ready for manipulation here
});