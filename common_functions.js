function select2DataCollectName(d) {
    if (d.children)
        d.children.forEach(select2DataCollectName);
    else if (d._children)
        d._children.forEach(select2DataCollectName);
    select2Data.push(d.name + d.initials);
}

function searchTree(d) {
    if (d.children)
        d.children.forEach(searchTree);
    else if (d._children)
        d._children.forEach(searchTree);
    var searchFieldValue = eval(searchField);
    if (searchFieldValue && searchFieldValue.match(searchText)) {
            // Walk parent chain
            var ancestors = [];
            var parent = d;
            while (typeof(parent) !== "undefined") {
                ancestors.push(parent);
                parent.class = "found";
                parent = parent.parent;
            }
    }
}

function clearAll(d) {
    d.class = "";
    if (d.children)
        d.children.forEach(clearAll);
    else if (d._children)
        d._children.forEach(clearAll);
}

function collapse(d) {
    if (d.children) {
        d._children = d.children;
        d._children.forEach(collapse);
        d.children = null;
    }
}

function collapseAllNotFound(d) {
    if (d.children) {
    	if (d.class !== "found") {
        	d._children = d.children;
        	d._children.forEach(collapseAllNotFound);
        	d.children = null;
	} else 
        	d.children.forEach(collapseAllNotFound);
    }
}

function expandAll(d) {
    if (d._children) {
        d.children = d._children;
        d.children.forEach(expandAll);
        d._children = null;
    } else if (d.children)
        d.children.forEach(expandAll);
}

// Toggle children
function toggle(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  clearAll(root);
  update(d);
  $("#searchName").select2("val", "");
}

function collapse(d) {
    if (d.children) {
      d._children = d.children;
      d._children.forEach(collapse);
      d.children = null;
    }
  }
  
  function toggleAll(d) {
    if (d.children) {
      d.children.forEach(toggleAll);
      toggle(d);
    }
  }
  
 function collapseExpandAll(d) {
	if (d.children) {
		collapse(d);
		update(d);
	} else {
		expandAll(d);
		update(d);
	}
}
