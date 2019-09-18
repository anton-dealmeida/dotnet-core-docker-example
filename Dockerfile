FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["DDDemoNetCore.csproj", ""]
RUN dotnet restore "./DDDemoNetCore.csproj"
COPY . .
WORKDIR /src/.
RUN dotnet build "DDDemoNetCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DDDemoNetCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DDDemoNetCore.dll"]  