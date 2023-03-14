using CoffeeShop.Contracts;
using CounterService.Domain;
using CounterService.Domain.DomainEvents;
using FluentValidation;
using MediatR;
using N8T.Core.Domain;
using N8T.Core.Repository;

namespace CounterService.Features;

public record BaristaOrderUpdatedCommand(Guid OrderId, Guid ItemLineId, string Name, ItemType ItemType, DateTime TimeIn,
    string MadeBy, DateTime TimeUp) : IRequest<IResult>;

internal class BaristaOrderUpdatedCommandValidator : AbstractValidator<BaristaOrderUpdatedCommand>
{
}

internal class BaristaOrderUpdatedCommandHandler : IRequestHandler<BaristaOrderUpdatedCommand, IResult>
{
    private readonly IRepository<Order> _orderRepository;
    private readonly IPublisher _publisher;
    private readonly ILogger<BaristaOrderUpdatedCommandHandler> _logger;

    public BaristaOrderUpdatedCommandHandler(IRepository<Order> orderRepository, IPublisher publisher, ILogger<BaristaOrderUpdatedCommandHandler> logger)
    {
        _orderRepository = orderRepository;
        _publisher = publisher;
        _logger = logger;
    }
    
    public async Task<IResult> Handle(BaristaOrderUpdatedCommand request, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);
        
        _logger.LogInformation("Order is {OrderId}", request.OrderId);

        var spec = new GetOrderByIdWithLineItemSpec(request.OrderId);
        var order = await _orderRepository.FindOneAsync(spec, cancellationToken);
        
        var orderUpdated = order.Apply(
            new OrderUp(
                request.OrderId, 
                request.ItemLineId, 
                request.ItemType.ToString(), 
                request.ItemType,
                request.TimeUp,
                request.MadeBy));
        
        await _orderRepository.EditAsync(orderUpdated, cancellationToken: cancellationToken);

        await order.RelayAndPublishEvents(_publisher, cancellationToken: cancellationToken);

        return Results.Ok();
    }
}
