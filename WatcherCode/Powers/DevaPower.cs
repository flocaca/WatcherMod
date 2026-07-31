using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Players;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models;
using Watcher.Code.Abstract;

namespace Watcher.Code.Powers;

public sealed class DevaPower : WatcherPowerModel
{
    public override PowerType Type => PowerType.Buff;

    protected override IEnumerable<DynamicVar> CanonicalVars =>
    [
        new EnergyVar(1)
    ];

    public override PowerStackType StackType => PowerStackType.Counter;

    public override async Task AfterEnergyReset(Player player)
    {
        if (player.Creature != Owner)
            return;

        // Give energy
        await PlayerCmd.GainEnergy(DynamicVars.Energy.IntValue, player);
        DynamicVars.Energy.UpgradeValueBy(Amount);
        Flash();
    }

    /*
    private NDevaFormVfx? _vfx;

    private NDevaFormVfx? Vfx
    {
        get => _vfx == null || _vfx.IsValid() ? _vfx : null;
        set
        {
            AssertMutable();
            _vfx = value;
        }
    }*/
    
    public override Task AfterApplied(Creature? applier, CardModel? cardSource)
    {
        /*Vfx = NDevaFormVfx.Create(Owner); */
        return Task.CompletedTask;
    }
    
    /*
    
    public override Task BeforeSideTurnStart(
        PlayerChoiceContext choiceContext,
        CombatSide side,
        IReadOnlyList<Creature> participants,
        ICombatState combatState)
    {
        if (!participants.Contains(Owner))
            return Task.CompletedTask;
        Vfx?.SetActive(true);
        return Task.CompletedTask;
    }


    public override Task AfterRemoved(Creature oldOwner)
    {
        Vfx?.SetActive(false);
        return Task.CompletedTask;
    }*/
}