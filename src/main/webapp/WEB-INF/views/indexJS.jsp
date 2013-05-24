<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
{
<c:if test="${not empty indexes}">
<c:set var="i" value="${indexes[0]}"/>
"version":"${i.version}",
"groupCount":${fn:length(groups)},
"groups":[
<c:forEach items="${groups}" var="group" varStatus="gs">
  <c:if test="${gs.count>1}">,</c:if>
  "${group}"
</c:forEach>
],
"indexCount":${fn:length(indexes)},
"indexes":[
<c:forEach items="${indexes}" var="index" varStatus="is">
  <c:if test="${is.count>1}">,</c:if>
  {
  "group":"${index.group}",
  "name":"${index.name}",
  "comment":"${index.dclass.comment}",
  "memory":${index.dclass.memory},
  "nodes":${index.dclass.nodes},
  "patterns":${index.dclass.patterns}
  }
</c:forEach>
]
</c:if>
}
