<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<body>
<h1>webClass</h1>
<form action="" method="GET">
Text: <input type="text" name="text" value="${text}">
<input type="submit" value="Submit">
</form>
<div style="font-family:Courier New;font-size:10pt;">
<c:if test="${not empty text}">
Text: ${text}<br>
Processing time: ${time}<br>
Results: ${fn:length(results)}<br>
<c:forEach items="${results}" var="result">
    <br>
    &nbsp;<b>Group: ${result.group}</b><br>
    &nbsp;<b>Name: ${result.name}</b><br>
    <c:forEach items="${result.result}" var="map">
        &nbsp;${map.key}: ${map.value}<br>
    </c:forEach>
</c:forEach>
<br>
<a href="class.js?text=${text}">JSON</a><br>
</c:if>
<a href="index">Indexes</a><br>
<a href="https://github.com/rezan/webClass">Source</a><br>
</div>
</body>
</html>
