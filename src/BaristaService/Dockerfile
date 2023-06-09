#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5003

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["NuGet.Config", "."]
COPY ["src/BaristaService/BaristaService.csproj", "src/BaristaService/"]
COPY ["src/Libs/CoffeeShop.Contracts/CoffeeShop.Contracts.csproj", "src/Libs/CoffeeShop.Contracts/"]
COPY ["src/Libs/N8T.Core/N8T.Core.csproj", "src/Libs/N8T.Core/"]
COPY ["src/Libs/N8T.Infrastructure.EfCore/N8T.Infrastructure.EfCore.csproj", "src/Libs/N8T.Infrastructure.EfCore/"]
COPY ["src/Libs/N8T.Infrastructure/N8T.Infrastructure.csproj", "src/Libs/N8T.Infrastructure/"]
RUN dotnet restore "src/BaristaService/BaristaService.csproj"
COPY . .
WORKDIR "/src/src/BaristaService"
RUN dotnet build "BaristaService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BaristaService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BaristaService.dll"]