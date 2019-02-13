

(function() {
  var root = this;
  var previous_LsDataConverter = root.LsDataConverter;

  var LsDataConverter = {
    convertUrl: function(url) {
      return url ? (url.match(/littlesis\.org/) ? url : "//littlesis.org" + url) : null;
    },

    convertEntity: function(e) {
      return {
        id: e.id,
        display: { 
          name: e.name,
          x: e.x,
          y: e.y,
          scale: e.scale ? e.scale : 1,
          status: e.status ? e.status : "normal",
          image: e.image,
          url: this.convertUrl(e.url)
        }    
      };
    },

    convertRel: function(r) {
      return {
        id: r.id,
        node1_id: r.entity1_id,
        node2_id: r.entity2_id,
        display: { 
          label: r.label,
          cx: r.x1,
          cy: r.y1,
          scale: r.scale ? r.scale : 1,
          arrow: r.is_directional,
          dash: r.is_current,
          status: r.status ? r.status : "normal",
          url: this.convertUrl(r.url)
        }
      };
    },

    convertText: function(t, id) {
      return {
        id: id,
        display: { 
          text: t.text, 
          x: t.x, 
          y: t.y 
        }
      };
    },

    convertMapData: function(data) {
      var that = this;

      var nodes =  data.entities.reduce(function(result, e) {
        result[e.id] = that.convertEntity(e);
        return result;
      }, {});

      var edges = data.rels.reduce(function(result, r) {
        result[r.id] = that.convertRel(r);
        return result;
      }, {});

      var captions = data.texts.reduce(function(result, t, i) {
        result[i+1] = that.convertText(t, i+1);
        return result;
      }, {});

      return {
        id: data.id,
        title: data.title,
        description: data.description,
        nodes: nodes,
        edges: edges,
        captions: captions
      };
    },

    convertMapCollectionData: function(data) {
      var that = this;

      return {
        id: data.id,
        title: data.title,
        graphs: data.maps.map(function(map) { 
          return that.convertMapData(map); 
        })
      };
    }
  }

  LsDataConverter.noConflict = function() {
    root.LsDataConverter = previous_LsDataConverter;
    return LsDataConverter;
  }

  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = LsDataConverter;
    }

    exports.LsDataConverter = LsDataConverter;
  } 
  else {
    root.LsDataConverter = LsDataConverter;
  }

}).call(this);

(function() {
  var root = this;
  var previous_LsDataSource = root.LsDataSource;

  var toQueryString = function(obj) {
    var parts = [];

    for (var i in obj) {
      if (obj.hasOwnProperty(i)) {
        if (Array.isArray(obj[i])) {
          obj[i].forEach(function(val) {
            parts.push(encodeURIComponent(i+"[]") + "=" + encodeURIComponent(val));
          });
        } else {
          parts.push(encodeURIComponent(i) + "=" + encodeURIComponent(obj[i]));
        }
      }
    }

    return parts.join("&");
  };

  var get = function(url, data, onSucess, onFail) {
    var httpRequest = new XMLHttpRequest();

    if (!httpRequest) {
      console.error('Giving up :( Cannot create an XMLHTTP instance');
      return false;
    }

    if (data) {
      var fullUrl = url + "?" + toQueryString(data);
    } else {
      console.error('Cannot make a request without data!');
      return false;
    }

    httpRequest.onreadystatechange = function() {
      if (httpRequest.readyState === 4) {
        if (httpRequest.status === 200) {
          onSucess(JSON.parse(httpRequest.responseText));
        } else {
          if (onFail) {
            onFail({ status: httpRequest.status, error: httpRequest.responseText });
          }
        }
      }
    };

    httpRequest.open('GET', fullUrl);
    httpRequest.send();
  };

  var LsDataSource = {
    name: 'LittleSis',
    baseUrl: '//littlesis.org',

    findNodes: function(text, callback) {
      get(
        this.baseUrl + '/maps/find_nodes', 
        { num: 12, desc: true, with_ids: true, q: text },
        callback
      );
    },

    getNodeWithEdges: function(nodeId, nodeIds, callback) {
      get(
        this.baseUrl + '/maps/node_with_edges',
        { node_id: nodeId, node_ids: nodeIds },
        callback
      );
    },

    getConnectedNodesOptions: {
      category_id: {
        1: "Position",
        2: "Education",
        3: "Membership",
        4: "Family",
        5: "Donation",
        6: "Transaction",
        7: "Lobbying",
        8: "Social",
        9: "Professional",
        10: "Ownership",
        11: "Hierarchy",
        12: "Generic"
      }
    },

    getConnectedNodes: function(nodeId, nodeIds, options, callback) {
      options = options || {};
      options.node_id = nodeId;
      options.node_ids = nodeIds;
      
      get(
        this.baseUrl + '/maps/edges_with_nodes',
        options,
        callback
      );
    },

    getInterlocks: function(node1Id, node2Id, nodeIds, options, callback) {
      options = options || {};
      options.node1_id = node1Id;
      options.node2_id = node2Id;
      options.node_ids = nodeIds;

      get(
        this.baseUrl + '/maps/interlocks',
        options,
        callback
      );
    }
  };

  LsDataSource.noConflict = function() {
    root.LsDataSource = previous_LsDataSource;
    return LsDataSource;
  };

  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = LsDataSource;
    }

    exports.LsDataSource = LsDataSource;
  } 
  else {
    root.LsDataSource = LsDataSource;
  }

}).call(this);
