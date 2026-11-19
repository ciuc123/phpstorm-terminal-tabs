package local.terminaltabs;

import com.intellij.terminal.frontend.view.TerminalAllowedActionsProvider;
import java.util.List;

/**
 * The reworked terminal (2026.3) removes NextTab/PreviousTab from the IDE actions it lets through
 * on Windows/Linux, then adds whatever this extension point supplies. Supplying them here brings
 * Alt+Left/Right (Select Previous/Next Tab) back inside terminal tabs.
 */
public final class TabActionsProvider implements TerminalAllowedActionsProvider {
  @Override
  public List<String> getActionIds() {
    return List.of("NextTab", "PreviousTab");
  }
}
