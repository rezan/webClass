<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
{
<c:if test="${not empty text}">
"text":"${text}",
"time":"${time}",
"resultCount":${fn:length(results)},
"results":[
<c:forEach items="${results}" var="result" varStatus="rs">
  <c:if test="${rs.count>1}">,</c:if>
  {
  "group":"${result.group}",
  "name":"${result.name}",
  <c:forEach items="${result.result}" var="map" varStatus="ms">
    <c:if test="${ms.count>1}">,</c:if>
    "${map.key}":"${map.value}"
  </c:forEach>
  }
</c:forEach>
]
</c:if>
}
