<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="application/javascript; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${not empty callback}">
${callback}(
<%@ include file="/WEB-INF/views/indexJS.jsp" %>
);
</c:if>
