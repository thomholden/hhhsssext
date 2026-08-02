function FacetedSearchField(searchField, hiddenField) {
    this.searchField = jQuery(searchField);
    this.hiddenField = jQuery(hiddenField);
    this.searchField.css('-moz-box-sizing', 'border-box');
    this.searchField.data('original_width', this.searchField.outerWidth());

    var facetsDiv = this.searchField.find('.facets');
    if (facetsDiv.length > 0) {
        this.facetsContainer = facetsDiv;
    } else {
        // Using pointer-events:none works everywhere but IE to keep the facets area from accepting mouse events.
        // The events are sent to the underlying search field instead.  This makes the click and drag behavior
        // really nice on browsers that support pointer-events.
        this.facetsContainer = jQuery('<div id="facets" style="position:absolute;pointer-events:none;"></div>');
        this.facetsContainer.insertAfter(this.searchField);
    }

    this.positionFacets();
    this.searchField.bind('mousedown', {'fsf':this, 'facets':false}, mouseDownHandler);
    this.facetsContainer.bind('mousedown', {'fsf':this, 'facets':true}, mouseDownHandler);

    this.searchField.bind('keydown', {'fsf':this}, keyDownHandler);

    this.getSearchForm().bind('submit', {'fsf':this}, submitHandler);
}

function submitHandler(evt) {
    var fsf = evt.data.fsf;
    var facetData = '';
    jQuery('.facet').each(function() {
        facetData += jQuery(this).data('form-data');
    });
    fsf.hiddenField.val(fsf.searchField.val() + facetData);
};

function mouseDownHandler(evt) {
    var fsf = evt.data.fsf;
    fsf.deselectAllFacets();

    if (evt.data.facets) {
        // This should only happen in browsers in which pointer-events is not supported.  It doesn't provide quite as
        // good a user experience, unfortunately.
        fsf.searchField.focus();
    }

    var mousedownat = evt.pageX;
    var mouseUpHandler = function() {
        jQuery(document).unbind('mouseup.searchField');
        jQuery(document).unbind('mousemove.searchField');
    };
    var mouseMoveHandler = function(evt) {
        var mouseat = evt.pageX;
        fsf.selectFacets(mousedownat, mouseat);
    };
    fsf.searchField.bind('mouseover', function() {
        fsf.searchField.focus();
        fsf.searchField.unbind('mouseover');
    });
    jQuery(document).bind('mouseup.searchField', mouseUpHandler);
    jQuery(document).bind('mousemove.searchField', mouseMoveHandler);
};

function keyDownHandler(evt) {
    var fsf = evt.data.fsf;
    var beforeType = fsf.searchField.val();
    fsf.searchField.bind('keyup.searchField', {'fsf':fsf, 'beforeDelete':beforeType}, keyUpHandler);

    if (evt.ctrlKey && evt.keyCode == 65) {
        fsf.getAllFacetElements().addClass('selected');
    }
}

function keyUpHandler(evt) {
    var fsf = evt.data.fsf;
    var afterKeyUp = fsf.searchField.val();
    if (afterKeyUp == evt.data.beforeDelete) {
        if (evt.keyCode == 8 || evt.keyCode == 46) {
            var deleted = fsf.deleteSelectedFacets();
            if (!deleted && evt.keyCode == 8) {
                fsf.selectLastFacet();
            }
        }
    } else {
        fsf.deleteSelectedFacets();
    }
    fsf.searchField.unbind('keyup.searchField');
    fsf.searchField.data('deleted', false);
}

FacetedSearchField.prototype.getSearchForm = function() {
  
    return this.searchField.closest('form');
};

FacetedSearchField.prototype.submitSearchForm = function() {
    this.getSearchForm().submit();
};

FacetedSearchField.prototype.positionFacets = function() {
    var pos = this.searchField.position();

    this.facetsContainer.css('top', pos.top+2);
    this.facetsContainer.css('left', pos.left+2);

    var facetsWidth = this.facetsContainer.outerWidth()+3;
    this.searchField.css('padding-left', facetsWidth);
    this.searchField.css('width', this.searchField.data('original_width')-facetsWidth);
    this.updateFacetBounds();
};

FacetedSearchField.prototype.getAllFacetElements = function() {
    return this.facetsContainer.find('.facet');
};

FacetedSearchField.prototype.updateFacetBounds = function() {
    var facetElts = this.getAllFacetElements();

    var positions = new Array();
    for (var i = 0; i < facetElts.length; i++) {
        var facetElt = jQuery(facetElts.get(i));
        var left = facetElt.offset().left;
        var right = left + facetElt.outerWidth();
        var mid = (left+right)/2;
        positions[i] = [left, mid, right];
    }
    this.searchField.data('facetPositions', positions);
};

FacetedSearchField.prototype.deselectAllFacets = function() {
    this.getAllFacetElements().removeClass('selected');
};

FacetedSearchField.prototype.selectFacets = function(x1, x2) {
    var facetPositions = this.searchField.data('facetPositions');
    var leftX = x1;
    var rightX = x2;
    if (x1 > x2) {
        leftX = x2;
        rightX = x1;
    }

    var facetElts = this.getAllFacetElements();
    for (var i = 0; i < facetPositions.length; i++) {
        var position = facetPositions[i];
        if ((leftX < position[0] && rightX > position[1]) || leftX < position[1] && rightX > position[2]) {
            jQuery(facetElts.get(i)).addClass('selected');
        } else {
            jQuery(facetElts.get(i)).removeClass('selected');
        }
    }
};

FacetedSearchField.prototype.addFacet = function(text, name, value) {
    var facetSpan = jQuery('<span class="facet"><span><img class="remove-facet" src="/matlabcentral/fileexchange/images/delete.png" style="pointer-events:auto;" /></span></span>');
    var facetText = jQuery('<span class="facet-text"></span>');
    facetText.prepend(text);
    facetSpan.prepend(facetText);
    facetSpan.data('form-data', ' ' + name + ':' + value);
    this.addFacetFunctionality(facetSpan);
    this.facetsContainer.append(facetSpan);

//    var hiddenField = jQuery('<input type="hidden" />');
//    hiddenField.attr('name', name);
//    hiddenField.attr('id', name);
//    hiddenField.val(value);
//    facetSpan.append(hiddenField);
//
    this.positionFacets();
};

FacetedSearchField.prototype.addFacetFunctionality = function(facet) {
    var fsf = this;
    facet.find('.remove-facet').mousedown(function() {
        fsf.deleteFacets(facet, true);
    });
};

FacetedSearchField.prototype.deleteFacets = function(facets, submit) {
    facets.remove();
    this.positionFacets();
    if (submit) {
        this.submitSearchForm();
    }
};

FacetedSearchField.prototype.selectLastFacet = function() {
    var lastFacet = this.getAllFacetElements().last();
    lastFacet.addClass('selected');
};

FacetedSearchField.prototype.deleteSelectedFacets = function() {
    var selected = this.getAllFacetElements().filter('.selected');
    if (selected.length > 0) {
        this.deleteFacets(selected, false);
        return true;
    } else {
        return false;
    }
};