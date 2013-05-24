<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<body>
<h1>webClass Index</h1>
<div style="font-family:Courier New;font-size:10pt;">
<c:if test="${not empty indexes}">
<c:set var="i" value="${indexes[0]}"/>
Version: ${i.version}<br>
Indexes: ${fn:length(indexes)}<br>
<c:forEach items="${indexes}" var="index">
    <br>
    &nbsp;<b>Group: ${index.group}</b><br>
    &nbsp;<b>Name: ${index.name}</b><br>
    &nbsp;Comment: ${index.dclass.comment}<br>
    &nbsp;Memory: ${index.dclass.memory} bytes<br>
    &nbsp;Nodes: ${index.dclass.nodes}<br>
    &nbsp;Patterns: ${index.dclass.patterns}<br>
</c:forEach>
<br>
<a href="index.js">JSON</a><br>
</c:if>
<a href="class">webClass</a><br>
<a href="https://github.com/rezan/webClass">Source</a><br>
</div>
</body>
</html>
